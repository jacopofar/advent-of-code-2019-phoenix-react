import React, { useState } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';
import axios from 'axios';

import { ProgramStepRepr, StateRepr } from './util/ProgramStepRepresentation';
import ProgramStepDisplay from './util/ProgramStepDisplay';


type ResponseRepr = {
    history: [ProgramStepRepr],
    final_map: StateRepr,
    result: number
};

// interface for part 2, much simpler
interface PartTwoSolution {
    a: number,
    b: number
};

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
    const [problemSolutionOne, setProblemSolutionOne] = useState<null | number>(null);
    const [problemSolutionTwo, setProblemSolutionTwo] = useState<null | PartTwoSolution>(null);

    const [resolutionHistory, setResolutionHistory] = useState<null | ResponseRepr>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            let values = problemInput.split(',').filter(k => k.length).map(Number);
            // change required by the problem, for part 2 is overwritten by the server
            values[1] = 12;
            values[2] = 2;
            if (part === 1) {
                const solution: { data: ResponseRepr } = await axios.post('/day02/' + part, values);
                setProblemSolutionOne(solution.data.result);
                setResolutionHistory(solution.data);
            }
            else {
                const solution: { data: PartTwoSolution } = await axios.post('/day02/' + part, values);
                setProblemSolutionTwo(solution.data);
            }
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
                <Box>For part 1, the values at position 0 and 1 are replaced with 12 and 1.</Box>
                <Box>Part 2 asks which values at index 1 and 2 produce a given output (19690720).</Box>
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

            <Typography variant="h3" gutterBottom>{problemSolutionOne ? `Solution: ${problemSolutionOne}` : 'Press Solve to get the solution'}
            </Typography>
            <Typography variant="h3" gutterBottom>{problemSolutionTwo ? `Solution: A: ${problemSolutionTwo.a} B: ${problemSolutionTwo.b} combined: ${problemSolutionTwo.a * 100 + problemSolutionTwo.b}` : null}
            </Typography>

            {resolutionHistory ? resolutionHistory.history.map(step => <ProgramStepDisplay step={step}></ProgramStepDisplay>) : null}
        </div>
    );
};

export default Day02;
