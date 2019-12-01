import React from 'react';
import { makeStyles, createStyles, Theme } from '@material-ui/core/styles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      '& > *': {
        margin: theme.spacing(1),
      },
    },
  }),
);

const Day02: React.FC = () => {
    const classes = useStyles();
    return (
        <div className={classes.root}>
        <header>
        <h2>Day 02</h2>
        </header>
        <p>Day 02 is still TBD</p>
        </div>
    );
};

export default Day02;
