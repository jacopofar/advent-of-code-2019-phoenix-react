import React, { useState } from 'react';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Box from '@material-ui/core/Box';
import Typography from '@material-ui/core/Typography';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import axios from 'axios';


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
            width: 300
        },
    }),
);


const Day01: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const classes = useStyles();

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split('\n').filter(k => k.length).map(Number)
            const solution: { data: { result: number } } = await axios.post('/day01/' + part, values);
            setProblemSolution(solution.data.result)
        };
        sendInput();
    };
    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };
    return (
        <div className={classes.root}>
            <header>
                <h2>Day 01 - Rocket fuel</h2>
            </header>
            <Typography component="div">
                <Box>Day 01, calculate the fuel of a list of modules, one per line.</Box>
                <Box>In the first part, the fuel for a module is (X / 3) - 2, using the floor for the division and ignoring negative results.</Box>
                <Box>In the second part, the fuel for the fuel is calculated, recursively. That is, it sums also the fuel to lift the fuel to lift the fuel, etc... until 0 is reached.</Box>
            </Typography>

            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="10"
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

            <div>{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</div>
        </div>
    );
};

export default Day01;
