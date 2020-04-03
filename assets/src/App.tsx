import React from 'react';
import './App.css';

import { makeStyles, Theme } from '@material-ui/core/styles';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import Box from '@material-ui/core/Box';

import Day01 from './Day01';
import Day02 from './Day02';
import Day03 from './Day03';
import Day04 from './Day04';
import Day05 from './Day05';
import Day06 from './Day06';
import Day07 from './Day07';
import Day08 from './Day08';
import Day09 from './Day09';
import Day10 from './Day10';
import Day12 from './Day12';
import Day13 from './Day13';
import Day14 from './Day14';
import Day18 from './Day18';
import Day20 from './Day20';


// interface for the single day element
interface TabPanelProps {
    children?: React.ReactNode;
    index: any;
    value: any;
}

function TabPanel(props: TabPanelProps) {
    const { children, value, index, ...other } = props;

    return (
        <Box
            component="div"
            role="tabpanel"
            hidden={value !== index}
            id={`vertical-tabpanel-${index}`}
            aria-labelledby={`vertical-tab-${index}`}
            {...other}
        >
            {children}
        </Box>
    );
}


//styling function for material-ui theme
const useStyles = makeStyles((theme: Theme) => ({
    root: {
        flexGrow: 1,
        backgroundColor: theme.palette.background.paper,
        display: 'flex',
        height: '100%',
    },
    tabs: {
        borderRight: `1px solid ${theme.palette.divider}`,
    },
}));

const App: React.FC = () => {
    const [day, setDay] = React.useState(8);
    const classes = useStyles();

    const handleChange = (event: React.ChangeEvent<{}>, newValue: number) => {
        setDay(newValue);
    };

    return (
        <div className={classes.root}>
            <Tabs
                orientation="vertical"
                variant="scrollable"
                value={day}
                onChange={handleChange}
                aria-label="Vertical tabs example"
                className={classes.tabs}
            >
                <Tab label="Day 1" />
                <Tab label="Day 2" />
                <Tab label="Day 3" />
                <Tab label="Day 4" />
                <Tab label="Day 5" />
                <Tab label="Day 6" />
                <Tab label="Day 7" />
                <Tab label="Day 8" />
                <Tab label="Day 9" />
                <Tab label="Day 10" />
                <Tab label="Day 11" />
                <Tab label="Day 12" />
                <Tab label="Day 13" />
                <Tab label="Day 14" />
                <Tab label="Day 18" />
                <Tab label="Day 20" />


            </Tabs>
            <TabPanel value={day} index={0}>
                <Day01></Day01>
            </TabPanel>

            <TabPanel value={day} index={1}>
                <Day02></Day02>
            </TabPanel>
            <TabPanel value={day} index={2}>
                <Day03></Day03>
            </TabPanel>
            <TabPanel value={day} index={3}>
                <Day04></Day04>
            </TabPanel>
            <TabPanel value={day} index={4}>
                <Day05></Day05>
            </TabPanel>
            <TabPanel value={day} index={5}>
                <Day06></Day06>
            </TabPanel>
            <TabPanel value={day} index={6}>
                <Day07></Day07>
            </TabPanel>
            <TabPanel value={day} index={7}>
                <Day08></Day08>
            </TabPanel>
            <TabPanel value={day} index={8}>
                <Day09></Day09>
            </TabPanel>
            <TabPanel value={day} index={9}>
                <Day10></Day10>
            </TabPanel>
            <TabPanel value={day} index={11}>
                <Day12></Day12>
            </TabPanel>
            <TabPanel value={day} index={12}>
                <Day13></Day13>
            </TabPanel>
            <TabPanel value={day} index={13}>
                <Day14></Day14>
            </TabPanel>
            <TabPanel value={day} index={17}>
                <Day18></Day18>
            </TabPanel>
            <TabPanel value={day} index={19}>
                <Day20></Day20>
            </TabPanel>
        </div>
    );
};

export default App;
