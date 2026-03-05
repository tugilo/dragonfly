import React from 'react';
import { List, Datagrid, TextField, FunctionField, TopToolbar, Button } from 'react-admin';
import { Link } from 'react-router-dom';

function MeetingsListActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsで編集</Button>
        </TopToolbar>
    );
}

function HeldOnField({ record, ...props }) {
    const d = record?.held_on;
    if (!d) return <span>—</span>;
    try {
        return <span>{new Date(d).toLocaleDateString('ja-JP')}</span>;
    } catch {
        return <span>{String(d)}</span>;
    }
}

export function MeetingsList() {
    return (
        <List
            title="Meetings"
            actions={<MeetingsListActions />}
            perPage={25}
        >
            <Datagrid rowClick={false}>
                <TextField source="number" label="回" />
                <FunctionField label="開催日" render={(r) => <HeldOnField record={r} />} />
                <TextField source="name" label="名前" emptyText="—" />
            </Datagrid>
        </List>
    );
}
