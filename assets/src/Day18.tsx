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

const Day18: React.FC = () => {
    const [problemInput, setProblemInput] = useState(`########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################`);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);

    const classes = useStyles();

    const handleInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const labyrinth = problemInput.split('\n').map(l => l.trim()).join('\n');
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day18/' + part, { labyrinth });
                setProblemSolution(solution.data.result);
            }
            if (part === 2) {
                const solution: { data: { result: number, cycles: [number] } } = await axios.post('/day18/' + part, { labyrinth });
                setProblemSolution(solution.data.result);
            }

        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 18 - Many-Worlds Interpretation</h2>
            </header>
            <Typography component="div">
                <Box>An orthogonal grid wtith obstacles forming a labyrinth map is given, the entry point marked with @.</Box>
                <Box>Some cells of the grid are keys, marked with lowercase latin letters, and some are doors, marked with uppercase letters. A door can be opened with the corresponding key.</Box>
                <Box>The goal is to find the shortest path that can get all the keys</Box>

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

export default Day18;
