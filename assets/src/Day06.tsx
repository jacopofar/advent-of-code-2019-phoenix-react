import React, { useState, useRef, useEffect } from 'react';
import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

import axios from 'axios';
import vis, { data } from 'vis-network';

type Edge = {
    from: string,
    to: string
};

type Graph = {
    edges: Edge[]
};

interface GraphProps {
    graph: Graph,
};


type PartTwoResponse = {
    edges: Edge[],
    result: number,
    shortest_path: string[]
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
            width: 200
        },
    }),
);


const ChartDisplay: React.FC<GraphProps> = (props) => {
    //NOTE trying to draw this chart basically breaks the browser
    //so it's commented out. There are indeed a lot of nodes, maybe it
    // just makes no sense to try and draw a chart?

    return null;
    // const graphVisRef = useRef<HTMLDivElement>(null);

    // useEffect(() => {
    //     if (graphVisRef.current) {
    //         const nodesWithDuplicates = props.graph.edges.map(e => e.from);

    //         const nodes = new vis.DataSet(nodesWithDuplicates.filter(
    //             (value, index, list) => list.indexOf(value) === index).map(
    //                 n => ({ id: n, label: n })));
    //         // edges appear twice, keep only one of them
    //         const edges = new vis.DataSet(props.graph.edges.filter(edge => edge.from > edge.to));
    //         new vis.Network(graphVisRef.current, { nodes, edges }, {})
    //     }
    // }, [graphVisRef])
    // return (<div ref={graphVisRef}></div>);
};

const Day06: React.FC = () => {
    const [problemInput, setProblemInput] = useState(`COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN`);
    const [problemSolution, setProblemSolution] = useState<null | number>(null);
    const [graph, setGraph] = useState<null | Graph>(null);

    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split('\n').filter(k => k.length).map(v => v.trim())
            if (part === 1) {
                const solution: { data: { result: number } } = await axios.post('/day06/' + part, values);
                setProblemSolution(solution.data.result);
            } else {
                const solution: { data: PartTwoResponse } = await axios.post('/day06/' + part, values);
                setProblemSolution(solution.data.result);
                setGraph({
                    edges: solution.data.edges
                });
            }
        };
        sendInput();
    };

    return (
        <div className={classes.root}>
            <header>
                <h2>Day 06 - Universal Orbit Map</h2>
            </header>
            <Typography component="div">
                <Box>Given a list of orbits in the form A)B meaning that B orbits around A, the first part asks to find how many "orbit relationships" are there.</Box>
                <Box>This requires to count not only the given orbits, but also the indirect ones, so if A)B and B)C and C)D then the orbits A)C, B)D and A)D are counted as well</Box>
                <Box>The second part requires to find the shortest path between "YOU" and "SAN" and count how many nodes are there in the middle.</Box>
                <Box>Note: the solution to the first part is VERY slow. It works but probably can be faster.</Box>
            </Typography>
            <TextField
                id="outlined-multiline-static"
                multiline
                fullWidth
                rows="20"
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
            <Typography variant="h5">{problemSolution ? `Solution: ${problemSolution}` : 'Press Solve to get the solution'}</Typography>
            {graph ? <ChartDisplay graph={graph}></ChartDisplay> : null}
        </div>
    );
};

export default Day06;
