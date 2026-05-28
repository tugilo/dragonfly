import React from 'react';
import {
    List,
    Datagrid,
    TextField,
    TopToolbar,
    CreateButton,
    EditButton,
    DeleteButton,
    useNotify,
} from 'react-admin';
import { Box, Typography } from '@mui/material';

function CategoriesListActions() {
    return (
        <TopToolbar>
            <CreateButton />
        </TopToolbar>
    );
}

export function CategoriesList() {
    const notify = useNotify();

    return (
        <List
            title="Settings — Categories"
            actions={<CategoriesListActions />}
            perPage={25}
        >
            <Box sx={{ px: 2, py: 1, bgcolor: 'warning.light', border: 1, borderColor: 'warning.main', borderRadius: 1, mx: 2, mb: 1 }}>
                <Typography variant="body2" color="warning.dark">
                    ⚠️ カテゴリの削除は、所属メンバーがいる場合は不可です。メンバーを別カテゴリへ移動してから削除してください。
                </Typography>
            </Box>
            <Datagrid rowClick="edit">
                <TextField source="group_name" label="大カテゴリ (group)" />
                <TextField source="name" label="実カテゴリ (name)" />
                <EditButton />
                <DeleteButton
                    confirmTitle="カテゴリを削除"
                    confirmContent="このカテゴリを削除してもよいですか？所属メンバーがいる場合はエラーになります。"
                    mutationOptions={{
                        onError: (error) => {
                            notify(error?.message || '削除に失敗しました', { type: 'error' });
                        },
                    }}
                />
            </Datagrid>
        </List>
    );
}
