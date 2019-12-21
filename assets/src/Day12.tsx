import React, { useState } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import Slider from '@material-ui/core/Slider';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import axios from 'axios';

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            width: 500,
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

const Day12: React.FC = () => {
    const [problemInput, setProblemInput] = useState(`<x=-6, y=2, z=-9>
<x=12, y=-14, z=-4>
<x=9, y=5, z=-6>
<x=-1, y=-4, z=9>
    `);
    const [simulationSteps, setSimulationSteps] = useState(1000);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [problemSolutionPeriodicity, setProblemSolutionPeriodicity] = useState<null | number[]>(null);

    const classes = useStyles();

    const handleInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const updateSimulationSteps = (event: React.ChangeEvent<{}>, value: number | number[]) => {
        setSimulationSteps(value as number);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const moons = problemInput
                .split('\n')
                .map(s => {
                    const match = /<x=(.+), y=(.+), z=(.+)>/.exec(s);
                    if (match)
                        return { x: Number(match[1]), y: Number(match[2]), z: Number(match[3]) }
                    else return null;
                }).filter(k => k);
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day12/' + part, { moons, simulationSteps });
                setProblemSolution(solution.data.result);
            }
            if (part === 2) {
                const solution: { data: { result: number, cycles: [number] } } = await axios.post('/day12/' + part, { moons, simulationSteps });
                setProblemSolution(solution.data.result);
                setProblemSolutionPeriodicity(solution.data.cycles);
            }

        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 12 - The N-Body Problem</h2>
            </header>
            <Typography component="div">
                <Box>A set of masses (Jupyter moons) is given, with 3D coordinates.</Box>
                <Box>In discrete time steps, calculate the motion of the moons based on unitary gravity. In each axis the acceleration generated by other moons is -1, 0 or +1 based only on that axis.</Box>
                <Box>For the second part, find after how many steps the system reaches the initial state. For this, the periodicity on each axis is calculates separately or it would be too hard to compute.</Box>
            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="6"
                className={classes.textField}
                margin="normal"
                variant="outlined"
                placeholder="Insert here the problem input"
                value={problemInput}
                onChange={handleInputChange}
            />
            <div className={classes.root}></div>

            <Slider
                defaultValue={1000}
                aria-labelledby="discrete-slider"
                valueLabelDisplay="on"
                step={100}
                marks
                min={0}
                max={1100}
                onChange={updateSimulationSteps}
            />
            <br />

            <Button variant="contained" color="primary" onClick={() => solve(1)}>Solve part 1!</Button>
            <Button variant="contained" color="secondary" onClick={() => solve(2)}>Solve part 2!</Button>
            <Typography variant="h5">{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</Typography>
            <Typography variant="h5">{problemSolutionPeriodicity ? ('Cycles: ' + problemSolutionPeriodicity.join(', ')) : null}</Typography>

        </div>
    );
};

export default Day12;
