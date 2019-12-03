export type Segment = {
    x1: number,
    y1: number
    x2: number,
    y2: number,
};

export type Intersection = {
    x: number,
    y: number,
};

export type PathRepr = {
    segments: Segment[],
    color: string,
}

export type GridRepr = {
    paths: PathRepr[],
    intersections: Intersection[]
};
