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

const Day10: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values: number[][] = problemInput.split('\n').filter(k => k.length).map(l => l.split('').map(e => e === '#' ? 1 : 0));
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day10/' + part, values);
                setProblemSolution(solution.data.result);
            }
            else {
                const solution: { data: { vaporized: number[][] } } = await axios.post('/day10/' + part, values);
                setProblemSolution(solution.data.vaporized[199][0] * 100 + solution.data.vaporized[199][1]);
            }
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 10 - Monitoring Station</h2>
            </header>
            <Typography component="div">
                <Box>An orthogonal grid where some cell are asteroids is given. The goal is to find the one that can "see" the most asteroids (itself included).</Box>
                <Box>An asteroid is visible from another when it's possible to draw a segment between them that doesn't contain another asteroid.</Box>
            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="30"
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
            <Typography variant="h5">{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</Typography>

        </div>
    );
};

export default Day10;
