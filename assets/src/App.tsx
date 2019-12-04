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
import Day05 from './Day04';


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
        height: 424,
    },
    tabs: {
        borderRight: `1px solid ${theme.palette.divider}`,
    },
}));

const App: React.FC = () => {
    const [day, setDay] = React.useState(3);
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

        </div>
    );
};

export default App;
