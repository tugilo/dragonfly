import React from 'react';
import { Edit, SimpleForm, TextInput, required, DeleteButton, useNotify } from 'react-admin';

export function CategoriesEdit() {
    const notify = useNotify();

    return (
        <Edit title="カテゴリ編集">
            <SimpleForm>
                <TextInput source="group_name" label="大カテゴリ (group_name)" validate={[required()]} fullWidth />
                <TextInput source="name" label="実カテゴリ (name)" validate={[required()]} fullWidth />
                <DeleteButton
                    confirmTitle="カテゴリを削除"
                    confirmContent="このカテゴリを削除してもよいですか？所属メンバーがいる場合はエラーになります。"
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
