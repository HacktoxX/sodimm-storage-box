#!/usr/bin/env python3
"""Validate topology, component count, spacing, and bounds of an ASCII STL."""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from pathlib import Path
import sys


Vertex = tuple[float, float, float]
Triangle = tuple[Vertex, Vertex, Vertex]
Bounds = tuple[Vertex, Vertex]


def parse_ascii_stl(path: Path) -> list[Triangle]:
    triangles: list[Triangle] = []
    current: list[Vertex] = []

    with path.open(encoding="utf-8") as handle:
        for line in handle:
            fields = line.split()
            if fields and fields[0] == "vertex":
                current.append(tuple(float(value) for value in fields[1:4]))
                if len(current) == 3:
                    triangles.append(tuple(current))
                    current = []

    if current:
        raise ValueError("STL ended with an incomplete triangle.")
    if not triangles:
        raise ValueError("STL contains no triangles.")

    return triangles


def mesh_analysis(
    triangles: list[Triangle],
) -> tuple[int, int, Bounds, list[Bounds]]:
    vertex_ids: dict[Vertex, int] = {}

    def vertex_id(vertex: Vertex) -> int:
        if vertex not in vertex_ids:
            vertex_ids[vertex] = len(vertex_ids)
        return vertex_ids[vertex]

    indexed = [
        tuple(vertex_id(vertex) for vertex in triangle)
        for triangle in triangles
    ]
    vertices_by_id = {
        identifier: vertex
        for vertex, identifier in vertex_ids.items()
    }

    edge_counts: Counter[tuple[int, int]] = Counter()
    edge_triangles: defaultdict[tuple[int, int], list[int]] = defaultdict(list)

    for triangle_index, triangle in enumerate(indexed):
        edges = (
            (triangle[0], triangle[1]),
            (triangle[1], triangle[2]),
            (triangle[2], triangle[0]),
        )
        for edge in edges:
            normalized = tuple(sorted(edge))
            edge_counts[normalized] += 1
            edge_triangles[normalized].append(triangle_index)

    nonmanifold_edges = sum(
        1 for count in edge_counts.values() if count != 2
    )

    adjacency = [set() for _ in indexed]
    for owners in edge_triangles.values():
        for owner in owners:
            adjacency[owner].update(
                other for other in owners if other != owner
            )

    remaining = set(range(len(indexed)))
    component_bounds: list[Bounds] = []

    while remaining:
        start = remaining.pop()
        stack = [start]
        members = {start}

        while stack:
            neighbors = adjacency[stack.pop()] & remaining
            remaining.difference_update(neighbors)
            members.update(neighbors)
            stack.extend(neighbors)

        component_vertex_ids = {
            vertex
            for triangle_index in members
            for vertex in indexed[triangle_index]
        }
        component_vertices = [
            vertices_by_id[vertex] for vertex in component_vertex_ids
        ]
        component_bounds.append(bounds(component_vertices))

    overall_bounds = bounds(list(vertex_ids))

    return (
        len(indexed),
        nonmanifold_edges,
        overall_bounds,
        component_bounds,
    )


def bounds(vertices: list[Vertex]) -> Bounds:
    minimum = tuple(
        min(vertex[axis] for vertex in vertices) for axis in range(3)
    )
    maximum = tuple(
        max(vertex[axis] for vertex in vertices) for axis in range(3)
    )
    return minimum, maximum


def dimensions(mesh_bounds: Bounds) -> Vertex:
    minimum, maximum = mesh_bounds
    return tuple(maximum[axis] - minimum[axis] for axis in range(3))


def close(actual: float, expected: float, tolerance: float) -> bool:
    return abs(actual - expected) <= tolerance


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("stl", type=Path)
    parser.add_argument("--components", type=int, required=True)
    parser.add_argument(
        "--size",
        type=float,
        nargs=3,
        metavar=("X", "Y", "Z"),
        required=True,
    )
    parser.add_argument("--min-y-gap", type=float)
    parser.add_argument("--tolerance", type=float, default=0.001)
    args = parser.parse_args()

    try:
        triangles = parse_ascii_stl(args.stl)
        (
            triangle_count,
            nonmanifold_edges,
            overall_bounds,
            component_bounds,
        ) = mesh_analysis(triangles)
    except (OSError, ValueError) as error:
        print(f"STL validation failed: {error}", file=sys.stderr)
        return 1

    actual_size = dimensions(overall_bounds)
    if nonmanifold_edges:
        print(
            f"STL has {nonmanifold_edges} edges without exactly two faces.",
            file=sys.stderr,
        )
        return 1
    if len(component_bounds) != args.components:
        print(
            "Expected "
            f"{args.components} components, found {len(component_bounds)}.",
            file=sys.stderr,
        )
        return 1
    if not all(
        close(actual, expected, args.tolerance)
        for actual, expected in zip(actual_size, args.size)
    ):
        print(
            f"Expected size {tuple(args.size)}, found {actual_size}.",
            file=sys.stderr,
        )
        return 1

    y_gaps: list[float] = []
    if args.min_y_gap is not None and len(component_bounds) > 1:
        ordered = sorted(component_bounds, key=lambda item: item[0][1])
        y_gaps = [
            ordered[index + 1][0][1] - ordered[index][1][1]
            for index in range(len(ordered) - 1)
        ]
        if any(
            gap + args.tolerance < args.min_y_gap for gap in y_gaps
        ):
            print(
                f"Expected Y gaps of at least {args.min_y_gap}, found {y_gaps}.",
                file=sys.stderr,
            )
            return 1

    print(
        f"{args.stl.name}: triangles={triangle_count}, "
        f"components={len(component_bounds)}, "
        f"nonmanifold_edges={nonmanifold_edges}, "
        f"size={actual_size}, y_gaps={y_gaps}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
