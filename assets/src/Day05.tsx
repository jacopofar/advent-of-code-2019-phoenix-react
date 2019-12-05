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

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            '& > *': {
                margin: theme.spacing(1),
            },
        },
        textField: {
            marginLeft: theme.spacing(1),
            marginRight: theme.spacing(1)
        },
    }),
);

const Day05: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [resolutionHistory, setResolutionHistory] = useState<null | ResponseRepr>(null);

    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split(',').filter(k => k.length).map(Number);
            const solution: { data: ResponseRepr } = await axios.post('/day05/' + part, values);
            setProblemSolution(solution.data.result);
            setResolutionHistory(solution.data);
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 05 - Sunny with a Chance of Asteroids</h2>
            </header>
            <Typography component="div">
                <Box>The computing tool implemented at day 2 is expanded with some I/O instruction and "immediate mode", that is, parameters can be passed as value and not only as a reference.</Box>
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
            <Typography variant="h5">{resolutionHistory ? resolutionHistory.history.map(step => <ProgramStepDisplay step={step}></ProgramStepDisplay>) : null}</Typography>

        </div>
    );
};

export default Day05;
