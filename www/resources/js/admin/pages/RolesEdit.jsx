import React from 'react';
import { Edit, SimpleForm, TextInput, required, DeleteButton, useNotify } from 'react-admin';

export function RolesEdit() {
    const notify = useNotify();

    return (
        <Edit title="役職編集">
            <SimpleForm>
                <TextInput source="name" label="役職名" validate={[required()]} fullWidth />
                <TextInput source="description" label="説明" multiline fullWidth />
                <DeleteButton
                    confirmTitle="役職を削除"
                    confirmContent="この役職を削除してもよいですか？役職履歴が存在する場合はエラーになります。"
                    mutationOptions={{
                        onError: (error) => {
                            notify(error?.message || '削除に失敗しました', { type: 'error' });
                        },
                    }}
                />
            </SimpleForm>
        </Edit>
    );
}
