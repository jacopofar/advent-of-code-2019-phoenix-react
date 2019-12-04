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
            width: 500
        },
    }),
);

const Day02: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            //const values = problemInput.split('\n').filter(k=>k.length).map(Number)
            //const solution: {data: {result: number}} = await axios.post('/day01/' + part, values);
            //setProblemSolution(solution.data.result)
            setProblemSolution(42)
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 04 - Secure Container</h2>
            </header>
            <Typography component="div">
                <Box>There is a range of numbers of 6 digits, and we have some criteria to filter them, for example the digits are never decreasing going left to right and there is a repeated digit.</Box>
                <Box>The goal is to count how many numbers in the given range satisfy the conditions.</Box>

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

            <div>{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</div>

        </div>
    );
};

export default Day02;
