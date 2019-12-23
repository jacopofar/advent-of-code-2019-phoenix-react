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

const Day13: React.FC = () => {
    const [problemInput, setProblemInput] = useState(``);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);

    const classes = useStyles();

    const handleInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
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

            const solution: { data: { result: number } } = await axios.post('/day13/' + part, { moons, simulationSteps: 1000 });
            setProblemSolution(solution.data.result);


        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 12 - TBD</h2>
            </header>
            <Typography component="div">
                <Box>Yet to be done</Box>
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

            <br />

            <Button variant="contained" color="primary" onClick={() => solve(1)}>Solve part 1!</Button>
            <Button variant="contained" color="secondary" onClick={() => solve(2)}>Solve part 2!</Button>
            <Typography variant="h5">{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</Typography>

        </div>
    );
};

export default Day13;
