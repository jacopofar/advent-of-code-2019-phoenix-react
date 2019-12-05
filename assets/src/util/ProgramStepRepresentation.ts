export type StateRepr = {
    [index: string]: number;
};

export type ProgramStepRepr = {
    op: string,
    current_state: StateRepr,
    input_pos: [number, number],
    target_pos: number,
    position: number
};
