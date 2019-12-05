import React from 'react';

import ExpansionPanel from '@material-ui/core/ExpansionPanel';
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary';
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import Typography from '@material-ui/core/Typography';
import Box from '@material-ui/core/Box';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import { ProgramStepRepr } from './ProgramStepRepresentation';

interface StepProps {
    step: ProgramStepRepr,
};


const useStyles = makeStyles((theme: Theme) =>
    createStyles({
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

const ProgramStepDisplay: React.FC<StepProps> = (props) => {
    const classes = useStyles();
    const s = props.step;
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
                <Typography className={classes.heading}>Operation: {s.op} {s.input_pos[0] ? `from ${s.input_pos[0]}` : null} {s.input_pos[0] ? `to ${s.input_pos[0]}` : null}  to {s.target_pos}</Typography>
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

export default ProgramStepDisplay;
