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

const Day07: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [bestInput, setBestInput] = useState<null | number[]>(null);

    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split(',').filter(k => k.length).map(Number);
            const solution: {
                data: {
                    result: number,
                    best_input: number[]
                }
            } = await axios.post('/day07/' + part, values);
            setProblemSolution(solution.data.result);
            setBestInput(solution.data.best_input);
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 07 - Amplification Circuit</h2>
            </header>
            <Typography component="div">
                <Box>We have a set of "computers" like the one implemented in day 5. </Box>
                <Box>Now each one has an initial input before 0 and 4, plus a secxond input given as an output by the preceding computer.</Box>
                <Box>The first part is implemented, the second one requires some redesign to allow the IntCode computer to stop and emit a continuation when there's no input available.</Box>

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

            <Typography variant="h5">{problemSolution && bestInput ? `Solution: ${problemSolution}, from input ${bestInput.join(',')}` : 'Press Solve to get the solution'}</Typography>

        </div>
    );
};

export default Day07;
