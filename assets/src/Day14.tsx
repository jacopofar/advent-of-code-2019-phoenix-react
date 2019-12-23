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

const Day14: React.FC = () => {
    const [problemInput, setProblemInput] = useState(``);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);

    const classes = useStyles();

    const handleInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const reactions = problemInput
                .split('\n').filter(line => line.length > 0)
                .map(r => {
                    const [reagents_repr, result_repr] = r.split('=>').map(s => s.trim());
                    const reagents = reagents_repr.split(',').map(s => s.trim()).map(entry => (
                        {
                            amount: Number(entry.split(' ')[0]),
                            reagent: entry.split(' ')[1],
                        }));
                    return {
                        reagents,
                        result_amount: Number(result_repr.split(' ')[0]),
                        result_type: result_repr.split(' ')[1],
                    }
                });
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day14/' + part, reactions);
                setProblemSolution(solution.data.result);
            }
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 14 - Space Stoichiometry</h2>
            </header>
            <Typography component="div">
                <Box>There are a set or reactions, each one transform some integer number of different elements in some number of a new one</Box>
                <Box>We have to "unwind" these reactions and calculate how much of a base element called ORE is required to get 1 unit of FUEL.</Box>

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

export default Day14;
