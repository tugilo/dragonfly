import React from 'react';
import {
    Edit,
    SimpleForm,
    TextInput,
    SelectInput,
    useGetList,
} from 'react-admin';

export function MemberEdit() {
    const { data: categories = [], isLoading: categoriesLoading } = useGetList('categories', {
        pagination: { page: 1, perPage: 500 },
        sort: { field: 'group_name', order: 'ASC' },
    });
    const { data: roles = [], isLoading: rolesLoading } = useGetList('roles', {
        pagination: { page: 1, perPage: 500 },
        sort: { field: 'name', order: 'ASC' },
    });

    const categoryChoices = categories.map((c) => ({
        id: c.id,
        name: c.name ? `${c.group_name} / ${c.name}` : c.group_name,
    }));
    const roleChoices = roles.map((r) => ({ id: r.id, name: r.name }));

    return (
        <Edit title="メンバー編集">
            <SimpleForm>
                <TextInput source="display_no" label="番号" fullWidth />
                <TextInput source="name" label="名前" fullWidth />
                <TextInput source="name_kana" label="ふりがな" fullWidth />
                <SelectInput
                    source="category_id"
                    label="カテゴリー"
                    choices={categoryChoices}
                    emptyValue={null}
                    emptyText="—"
                    fullWidth
                    disabled={categoriesLoading}
                />
                <SelectInput
                    source="role_id"
                    label="役職"
                    choices={roleChoices}
                    emptyValue={null}
                    emptyText="—"
                    fullWidth
                    disabled={rolesLoading}
                />
                <SelectInput
                    source="type"
                    label="区分"
                    choices={[
                        { id: 'active', name: '在籍' },
                        { id: 'member', name: 'メンバー' },
                        { id: 'visitor', name: 'ビジター' },
                        { id: 'inactive', name: '休会・退会' },
                        { id: 'guest', name: 'ゲスト' },
                    ]}
                    fullWidth
                />
            </SimpleForm>
        </Edit>
    );
}
