import React from 'react';
import { Show, SimpleShowLayout, TextField, FunctionField } from 'react-admin';
import { Box, Typography } from '@mui/material';

function CategoryField({ record }) {
    const c = record?.category;
    if (!c) return <span>—</span>;
    return <span>{c.group_name} / {c.name}</span>;
}

export function MemberShow() {
    return (
        <Show title="メンバー詳細">
            <SimpleShowLayout>
                <TextField source="display_no" label="番号" />
                <TextField source="name" label="名前" />
                <FunctionField label="カテゴリ" render={(r) => <CategoryField record={r} />} />
                <TextField source="current_role" label="現在の役職" emptyText="—" />
                <Box sx={{ mt: 2, p: 2, bgcolor: 'grey.100', borderRadius: 1 }}>
                    <Typography variant="subtitle2" color="text.secondary">
                        メモ履歴・1to1履歴
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                        （Coming soon — 一覧の「メモ」「1to1」「1to1メモ」から操作できます）
                    </Typography>
                </Box>
            </SimpleShowLayout>
        </Show>
    );
}
