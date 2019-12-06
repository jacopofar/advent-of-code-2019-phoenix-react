import React, { useState } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
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
            width: 200
        },
    }),
);

const Day06: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split('\n').filter(k=>k.length)
            const solution: {data: {result: number}} = await axios.post('/day06/' + part, values);
            setProblemSolution(solution.data.result)
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 06 - Universal Orbit Map</h2>
            </header>
            <Typography component="div">
                <Box>Given a list of orbits in the form A)B meaning that B orbits around A, the first part asks to find how many "orbit relationships" are there.</Box>
                <Box>This requires to count not only the given orbits, but also the indirect ones, so if A)B and B)C and C)D then the orbits A)C, B)D and A)D are counted as well</Box>

            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="20"
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

export default Day06;
