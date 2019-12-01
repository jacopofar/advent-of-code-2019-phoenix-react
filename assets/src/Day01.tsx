import React, { useState } from 'react';
import axios from 'axios';


const Day01: React.FC = () => {
    const [problemInput, setProblemInput] = useState('');
    const [problemSolution, setProblemSolution] = useState<null|number>(null);

    const solve = (part: number) => {
        const sendInput = async () => {
            const values = problemInput.split('\n').filter(k=>k.length).map(Number)
            const solution: {data: {result: number}} = await axios.post('/day01/' + part, values);
            setProblemSolution(solution.data.result)
        };
        sendInput();
    };
    const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
        setProblemInput(event.target.value);
    };
  return (
    <div>
      <header>
       Day 01
      </header>
      <p>Hello I am Day 01</p>
      <textarea
        rows={10}
        cols={120}
        value={problemInput}
        onChange={handleChange}>
      </textarea>
      <br/>
      <button onClick={() => solve(1)}>solve part 1!</button>
      <button onClick={() => solve(2)}>solve part 2!</button>

      <div>{problemSolution?`Solution: ${problemSolution}`:'Press Solve to get the solution'}</div>
    </div>
  );
};

export default Day01;
