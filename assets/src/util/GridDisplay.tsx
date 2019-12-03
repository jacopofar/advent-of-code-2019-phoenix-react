import React from 'react';
import { GridRepr, PathRepr } from './GridRepresentation';
import Box from '@material-ui/core/Box';

interface GridProps {
    gridData: GridRepr | null,
};

const representPath = (p: PathRepr) => {
    return <g>
        {p.segments.map((s) => <line
            x1={s.x1}
            y1={s.y1}
            x2={s.x2}
            y2={s.y2}
            style={{
                stroke: p.color,
                strokeWidth: 2
            }} />)}
    </g>
};

const GridDisplay: React.FC<GridProps> = (props) => {
    return <Box>
        <svg>
            {props.gridData ? props.gridData.paths.map(representPath) : null}
        </svg>
    </Box>
};

export default GridDisplay;
