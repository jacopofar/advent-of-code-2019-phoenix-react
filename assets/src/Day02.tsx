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
    const [resolutionHistory, setResolutionHistory] = useState<null | number>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split(',').filter(k => k.length).map(Number)
            const solution: { data: { result: number } } = await axios.post('/day02/' + part, values);
            setProblemSolution(solution.data.result)
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 02 - 1202 Program Alarm</h2>
            </header>
            <Typography component="div">
                <Box>Day 02, execute a "program" with opcodes and arithmetical instructions.</Box>
                <Box>Opcode 1 adds, opcode 2 multiplies, and 99 halts. 1 and 2 are followed by the addresses of the two inputs and then the address where to store the output.</Box>
                <Box>When the program halts, the result is the first value of the array.</Box>
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

            <Typography variant="h3" gutterBottom>{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}
            </Typography>

        </div>
    );
};

export default Day02;
