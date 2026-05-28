import React from 'react';
import { Create, SimpleForm, TextInput, required } from 'react-admin';

export function RolesCreate() {
    return (
        <Create title="役職追加">
            <SimpleForm>
                <TextInput source="name" label="役職名" validate={[required()]} fullWidth />
                <TextInput source="description" label="説明" multiline fullWidth />
            </SimpleForm>
        </Create>
    );
}
