import React from 'react';
import { GridRepr, PathRepr, Intersection } from './GridRepresentation';
import Box from '@material-ui/core/Box';

interface GridProps {
    gridData: GridRepr | null,
    height: number,
    width: number,
};

interface BoundingBox {
    minX: number,
    maxX: number,
    minY: number,
    maxY: number,
};

const FRAME_MARGIN = 5;
const representPath = (p: PathRepr, key: number) => {
    return <g key={key}>
        {p.segments.map((s, i) => <line
            key={i}
            x1={s.x1}
            y1={s.y1}
            x2={s.x2}
            y2={s.y2}
            style={{
                stroke: p.color,
                // estimation of the stroke size based on the scale
                strokeWidth: p.segments.length / 40
            }} />)}
    </g>
};


const representIntersections = (ints: Intersection[]) => {
    const size = ints.length / 3;
    return <g key="intersections">
        {ints.map((int, i) => <rect
            key={i}
            x={int.x - size}
            y={int.y - size}
            height={size * 2}
            width={size * 2}
            style={{
                stroke: "black",
            }} />)}
    </g>
};

const GridDisplay: React.FC<GridProps> = (props) => {
    const minMax = {
        minX: 0,
        maxX: 0,
        minY: 0,
        maxY: 0,
    };
    // find the bounding box
    if (props.gridData) {
        props.gridData.paths.forEach(path => {
            path.segments.forEach(s => {
                minMax.maxX = Math.max(minMax.maxX, s.x1)
                minMax.maxX = Math.max(minMax.maxX, s.x2)
                minMax.maxY = Math.max(minMax.maxY, s.y1)
                minMax.maxY = Math.max(minMax.maxY, s.y2)

                minMax.minX = Math.min(minMax.minX, s.x1)
                minMax.minX = Math.min(minMax.minX, s.x2)
                minMax.minY = Math.min(minMax.minY, s.y1)
                minMax.minY = Math.min(minMax.minY, s.y2)
            });
        });
        console.log(minMax, props.gridData.paths);
    }
    return <Box>
        <svg
            width={props.width}
            height={props.height}
            viewBox={`${minMax.minX - FRAME_MARGIN} ${minMax.minY - FRAME_MARGIN} ${minMax.maxX - minMax.minX + FRAME_MARGIN} ${minMax.maxY - minMax.minY + FRAME_MARGIN}`}>
            {props.gridData ? props.gridData.paths.map((p, i) => representPath(p, i)) : null}
            {props.gridData ? representIntersections(props.gridData.intersections) : null}

            {/*
            Disabled because not performant
             {props.gridData ? representGrid(minMax) : null} */}

        </svg>
    </Box>
};

export default GridDisplay;
