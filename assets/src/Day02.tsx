import React, { useState } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import ExpansionPanel from '@material-ui/core/ExpansionPanel';
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary';
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import axios from 'axios';

// interface for the resolution
interface StateRepr {
    [index: string]: number;
};

interface StepRepr {
    op: string,
    current_state: StateRepr,
    input_pos: [number, number],
    target_pos: number,
    position: number
};

interface ResponseRepr {
    history: [StepRepr],
    final_map: StateRepr,
    result: number
}


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
        heading: {
            fontSize: theme.typography.pxToRem(15),
            fontWeight: theme.typography.fontWeightRegular,
        },
        table: {
            "& td": {
                border: '1px solid #555',
                background: '#eee',
                padding: '3px',
                width: '2em',
            },
            "& th": {
                border: '1px solid black',
            },
        },
    }),
);

const Day02: React.FC = () => {
    const [problemInput, setProblemInput] = useState('1, 1, 1, 4, 99, 5, 6, 0, 99');
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [resolutionHistory, setResolutionHistory] = useState<null | ResponseRepr>(null);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            let values = problemInput.split(',').filter(k => k.length).map(Number);
            // change required by the problem
            values[1] = 12;
            values[2] = 2;
            const solution: { data: ResponseRepr } = await axios.post('/day02/' + part, values);
            setProblemSolution(solution.data.result);
            setResolutionHistory(solution.data)
        };
        sendInput();
    };
    const representStep = (s: StepRepr) => {
        const sortedKeys: string[] = Object.keys(s.current_state).sort((a, b) => (Number(a) < Number(b)) ? -1 : 0);
        const markedElements = sortedKeys.map((i: string) => ({
            value: s.current_state[i],
            isInput: s.input_pos.includes(Number(i)),
            isTarget: s.target_pos === Number(i),
            isOp: s.position === Number(i),
        }));
        return (
            <ExpansionPanel>
                <ExpansionPanelSummary
                    expandIcon={<ExpandMoreIcon />}
                    aria-controls="panel1a-content"
                    id="panel1a-header"
                >
                    <Typography className={classes.heading}>Operation: {s.op} from {s.input_pos[0]}, {s.input_pos[1]}  to {s.target_pos}</Typography>
                </ExpansionPanelSummary>
                <ExpansionPanelDetails>
                    <Typography>
                        <Box>State of the array before the operation</Box>
                        <table className={classes.table}>
                            <tr>
                                <th><strong>Index:</strong></th>
                                {sortedKeys.map(i => <th>{i}</th>)}
                            </tr>
                            <tr>
                                <td>Value:</td>
                                {markedElements.map(k => <td>{k.value}</td>)}</tr>
                            <tr>
                                <td>Is OP?</td>
                                {markedElements.map(k => <td>{k.isOp ? <strong>X</strong> : null}</td>)}</tr>
                            <tr>
                                <td>Is input?</td>
                                {markedElements.map(k => <td>{k.isInput ? <strong>X</strong> : null}</td>)}</tr>
                            <tr>
                                <td>Is output?</td>
                                {markedElements.map(k => <td>{k.isTarget ? <strong>X</strong> : null}</td>)}</tr>
                        </table>
                    </Typography>
                </ExpansionPanelDetails>
            </ExpansionPanel>
        );
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
            {resolutionHistory ? resolutionHistory.history.map(representStep) : null}
        </div>
    );
};

export default Day02;
