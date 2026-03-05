import React from 'react';
import { Create, SimpleForm, TextInput, required } from 'react-admin';

export function CategoriesCreate() {
    return (
        <Create title="カテゴリ追加">
            <SimpleForm>
                <TextInput source="group_name" label="大カテゴリ (group_name)" validate={[required()]} fullWidth />
                <TextInput source="name" label="実カテゴリ (name)" validate={[required()]} fullWidth />
            </SimpleForm>
        </Create>
    );
}
