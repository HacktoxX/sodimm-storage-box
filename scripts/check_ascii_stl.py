#!/usr/bin/env python3
"""Prüft Topologie, Komponenten, Abstände und Grenzen einer ASCII-STL."""

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
        raise ValueError("Die STL endet mit einem unvollständigen Dreieck.")
    if not triangles:
        raise ValueError("Die STL enthält keine Dreiecke.")

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
    parser = argparse.ArgumentParser(
        description="Prüft eine von OpenSCAD erzeugte ASCII-STL."
    )
    parser.add_argument("stl", type=Path, help="Pfad zur prüfenden STL-Datei")
    parser.add_argument(
        "--components",
        type=int,
        required=True,
        help="Erwartete Anzahl getrennter Komponenten",
    )
    parser.add_argument(
        "--size",
        type=float,
        nargs=3,
        metavar=("X", "Y", "Z"),
        required=True,
        help="Erwartete Gesamtabmessungen in Millimetern",
    )
    parser.add_argument(
        "--min-y-gap",
        type=float,
        help="Kleinster zulässiger Y-Abstand zwischen Komponenten",
    )
    parser.add_argument(
        "--tolerance",
        type=float,
        default=0.001,
        help="Zulässige Maßabweichung; Standard: 0.001",
    )
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
        print(f"STL-Prüfung fehlgeschlagen: {error}", file=sys.stderr)
        return 1

    actual_size = dimensions(overall_bounds)
    if nonmanifold_edges:
        print(
            f"Die STL besitzt {nonmanifold_edges} Kanten ohne genau zwei Flächen.",
            file=sys.stderr,
        )
        return 1
    if len(component_bounds) != args.components:
        print(
            f"Erwartet: {args.components} Komponenten; "
            f"gefunden: {len(component_bounds)}.",
            file=sys.stderr,
        )
        return 1
    if not all(
        close(actual, expected, args.tolerance)
        for actual, expected in zip(actual_size, args.size)
    ):
        print(
            f"Erwartete Abmessungen: {tuple(args.size)}; "
            f"gefunden: {actual_size}.",
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
                f"Erwartete Y-Abstände von mindestens {args.min_y_gap}; "
                f"gefunden: {y_gaps}.",
                file=sys.stderr,
            )
            return 1

    print(
        f"{args.stl.name}: Dreiecke={triangle_count}, "
        f"Komponenten={len(component_bounds)}, "
        f"Nicht-Manifold-Kanten={nonmanifold_edges}, "
        f"Abmessungen={actual_size}, Y-Abstände={y_gaps}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
