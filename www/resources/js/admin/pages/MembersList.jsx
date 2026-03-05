import React from 'react';
import { List, Datagrid, TextField, FunctionField, TopToolbar, Button } from 'react-admin';
import { Link } from 'react-router-dom';

function MembersListActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/" variant="outlined" size="small">
                Board へ戻る
            </Button>
        </TopToolbar>
    );
}

function CategoryField({ record, ...props }) {
    const c = record?.category;
    if (!c) return <span>—</span>;
    const text = c.name ? `${c.group_name} / ${c.name}` : c.group_name;
    return <span>{text}</span>;
}

function SameRoomCountField({ record, ...props }) {
    const n = record?.summary_lite?.same_room_count;
    if (n == null) return <span>—</span>;
    return <span>{n}</span>;
}

function LastMemoField({ record, ...props }) {
    const body = record?.summary_lite?.last_memo?.body_short;
    if (!body) return <span>—</span>;
    return <span title={body}>{body.length > 20 ? `${body.slice(0, 20)}…` : body}</span>;
}

export function MembersList() {
    return (
        <List
            title="Members（メンバー）"
            actions={<MembersListActions />}
            perPage={25}
        >
            <Datagrid rowClick="edit">
                <TextField source="display_no" label="番号" emptyText="—" />
                <TextField source="name" label="名前" />
                <FunctionField label="カテゴリー" render={(r) => <CategoryField record={r} />} />
                <TextField source="current_role" label="役職" emptyText="—" />
                <FunctionField label="同室回数" render={(r) => <SameRoomCountField record={r} />} />
                <FunctionField label="直近メモ" render={(r) => <LastMemoField record={r} />} />
            </Datagrid>
        </List>
    );
}
