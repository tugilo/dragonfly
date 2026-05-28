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

function RolesListActions() {
    return (
        <TopToolbar>
            <CreateButton />
        </TopToolbar>
    );
}

export function RolesList() {
    const notify = useNotify();

    return (
        <List
            title="Settings — Roles"
            actions={<RolesListActions />}
            perPage={25}
        >
            <Datagrid rowClick="edit">
                <TextField source="name" label="役職名" />
                <TextField source="description" label="説明" />
                <EditButton />
                <DeleteButton
                    confirmTitle="役職を削除"
                    confirmContent="この役職を削除してもよいですか？役職履歴が存在する場合はエラーになります。"
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
