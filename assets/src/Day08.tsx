import React, { useState, useEffect } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import InputLabel from '@material-ui/core/InputLabel';
import MenuItem from '@material-ui/core/MenuItem';
import Select from '@material-ui/core/Select';
import FormControl from '@material-ui/core/FormControl';
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
        formControl: {
            margin: theme.spacing(1),
            minWidth: 120,
        },
        errorNote: {
            color: theme.palette.error.main,
            fontWeight: 'bold'
        },
        table: {
            "& td": {
                border: '1px solid #555',
                padding: '3px',
                width: '1em',
            },
            "& th": {
                border: '1px solid black',
            },
        },
    }),
);

const Day08: React.FC = () => {
    const [problemImageInput, setProblemImageInput] = useState(`123
456

789
012`);
    const [problemImageSize, setProblemImageSize] = useState<string>('3x2');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [problemInput, setProblemInput] = useState<{ w: number, h: number, rawImage: string }>({ w: 0, h: 0, rawImage: '' });
    const [inputErrorMessage, setInputErrorMessage] = useState<string | null>(null);
    const [problemImage, setProblemImage] = useState<null | number[][]>(null);

    const classes = useStyles();

    const handleProblemInputChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemImageInput(event.target.value);
    };
    const handleImageSizeChange = (event: React.ChangeEvent<{ value: unknown }>) => {
        setProblemImageSize(event.target.value as string);
    };

    useEffect(() => {
        const [w, h] = problemImageSize.split('x').map((i) => parseInt(i));
        const cleanInput = problemImageInput.replace(/(\s|\r|\t)/g, '')
        if (cleanInput.length % (w * h) !== 0) {
            setInputErrorMessage(`Wrong input: the input length is ${cleanInput.length} which is not multiple of ${w * h} (${w} x ${h})`);
        }
        else {
            if (!/^\d+$/.test(cleanInput)) {
                setInputErrorMessage(`Wrong input: should be only digits!`);
            }
            else {
                setInputErrorMessage(null);
                setProblemInput({ w, h, rawImage: cleanInput });
            }
        }
    }, [problemImageInput, problemImageSize]);


    const solve = (part: number) => {
        const sendInput = async () => {
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day08/1', problemInput);
                setProblemSolution(solution.data.result);
                setProblemImage(null);
            }
            if (part === 2) {
                const solution: { data: { result: number[][] } } = await axios.post('/day08/2', problemInput);
                setProblemImage(solution.data.result);
                setProblemSolution(null);
            }
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 08 - Space Image Format</h2>
            </header>
            <Typography component="div">
                <Box>A list of digits is arranged in a grid of a given size by filling it left to right and then top to bottom.</Box>
                <Box>When the digits fill the grid, another layer is created and eventually some number of layers are filled.</Box>
                <Box>The first part asks to find the layer with fewest 0 digits and on that multiply the amount of 1 and 2</Box>
            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="5"
                className={classes.textField}
                margin="normal"
                variant="outlined"
                placeholder="Insert here the problem input"
                value={problemImageInput}
                onChange={handleProblemInputChange}
            />
            <br />
            <FormControl variant="filled" className={classes.formControl}>
                <InputLabel id="space-image-size-select-label">Image Size</InputLabel>
                <Select
                    labelId="space-image-size-select-label"
                    value={problemImageSize}
                    onChange={handleImageSizeChange}
                >
                    <MenuItem value={'3x2'}>3 x 2</MenuItem>
                    <MenuItem value={'25x6'}>25 x 6</MenuItem>
                </Select>
            </FormControl>
            <br />
            <Typography className={classes.errorNote} variant="overline" display="block" gutterBottom>{inputErrorMessage}</Typography>
            <Button variant="contained" disabled={inputErrorMessage !== null} color="primary" onClick={() => solve(1)}>Solve part 1!</Button>
            <Button variant="contained" disabled={inputErrorMessage !== null} color="secondary" onClick={() => solve(2)}>Solve part 2!</Button>
            <Typography variant="h5">{(problemSolution || problemImage) ? `Solution: ${problemSolution ? problemSolution : ''}` : 'Press Solve to get the solution'}</Typography>
            {problemImage ?
                <table className={classes.table}>
                    {problemImage.map(row => <tr>
                        {row.map(e => <td style={{
                            backgroundColor: (e === 1 ? 'white' : 'black'),
                            color: (e === 1 ? 'black' : 'white'),
                        }}>{e}</td>)}
                    </tr>)}
                </table>
                : null}

        </div>
    );
};

export default Day08;
