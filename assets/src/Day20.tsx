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

const Day20: React.FC = () => {
    const [problemInput, setProblemInput] = useState(`         A
    A
#######.#########
#######.........#
#######.#######.#
#######.#######.#
#######.#######.#
#####  B    ###.#
BC...##  C    ###.#
##.##       ###.#
##...DE  F  ###.#
#####    G  ###.#
#########.#####.#
DE..#######...###.#
#.#########.###.#
FG..#########.....#
###########.#####
        Z
        Z       `);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);

    const classes = useStyles();

    const handleInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const labyrinth = problemInput.split('\n').map(l => l.trim()).join('\n');
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day20/' + part, { labyrinth });
                setProblemSolution(solution.data.result);
            }
            if (part === 2) {
                const solution: { data: { result: number, cycles: [number] } } = await axios.post('/day20/' + part, { labyrinth });
                setProblemSolution(solution.data.result);
            }

        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 20 - Donut Maze</h2>
            </header>
            <Typography component="div">
                <Box>It's a labyrinth more than a 🍩, really. In this labyrinth there's a start position and a goal to reach.</Box>
                <Box>Some cells of the grid are uppercase latin letters and represent teleport portals. A cell marked as X teleports one to the other X on the board.</Box>
                <Box>The goal is to find the shortest path that can goes from start to end, using the teleport if necessary to shorten it.</Box>
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

export default Day20;
