import React, { useState } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import axios from 'axios';

import { Segment, GridRepr, Intersection } from './util/GridRepresentation';
import GridDisplay from './util/GridDisplay';

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            '& > *': {
                margin: theme.spacing(1),
            },
        },
        textField: {
            marginLeft: theme.spacing(1),
            marginRight: theme.spacing(1),
            width: 500
        },
    }),
);

const Day03: React.FC = () => {
    const [problemInput, setProblemInput] = useState(`R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83`);
    const [problemOneSolution, setProblemOneSolution] = useState<null | number>(null);
    const [gridRepresentation, setGridRepresentation] = useState<null | GridRepr>(null);

    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const [pathA, pathB] = problemInput.split('\n').filter(k => k.length).map(p => p.trim().split(','))
            const solution: {
                data: {
                    result: number,
                    segments_a: Segment[],
                    segments_b: Segment[],
                    intersections: Intersection[],
                }
            } = await axios.post('/day03/' + part, {
                a: pathA,
                b: pathB
            });
            setProblemOneSolution(solution.data.result);
            setGridRepresentation({
                paths: [
                    {
                        segments: solution.data.segments_a,
                        color: 'red'
                    },
                    {
                        segments: solution.data.segments_b,
                        color: 'blue'
                    }
                ],
                intersections: solution.data.intersections,
            });
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 03 - Crossed Wires</h2>
            </header>
            <Typography component="div">
                <Box>There are two wires following two circuits over an orthogonal grid, starting at the same origin point.</Box>
                <Box>Each circuit is described as a sequence of movements on the grid, for example U12,L23 means up 13 cells and then left 23 cells.</Box>
                <Box>The first part asks to find the point closest (manhattan distance) to the origin where they intersect, origin excluded.</Box>

            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="2"
                className={classes.textField}
                margin="normal"
                variant="outlined"
                placeholder="Insert here the problem input"
                value={problemInput}
                onChange={handleChange}
            />
            <br />

            <Button variant="contained" color="primary" onClick={() => solve(1)}>Solve part 1!</Button>
            <Button variant="contained" color="secondary" onClick={() => solve(2)}>Solve part 2!</Button>

            <Typography variant="h5">{problemOneSolution ? `Solution: ${problemOneSolution}` : 'Press Solve to get the solution'}</Typography>
            <GridDisplay
                gridData={gridRepresentation}
                height={600}
                width={800}></GridDisplay>
        </div>
    );
};

export default Day03;
