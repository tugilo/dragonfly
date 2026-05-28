import React from 'react';
import {
    List,
    Datagrid,
    TextField,
    DateField,
    FunctionField,
    SelectInput,
    ReferenceInput,
    DateInput,
    useGetList,
} from 'react-admin';

function StatusField({ record, ...props }) {
    if (!record) return null;
    const isCurrent = record.term_end == null || record.term_end === '';
    return <span>{isCurrent ? '現役' : '過去'}</span>;
}

export function MemberRolesList() {
    const { data: roles = [] } = useGetList('roles', {
        pagination: { page: 1, perPage: 500 },
        sort: { field: 'name', order: 'ASC' },
    });
    const roleChoices = roles.map((r) => ({ id: r.id, name: r.name }));

    return (
        <List
            title="役職履歴（member-roles）"
            perPage={25}
            sort={{ field: 'term_start', order: 'DESC' }}
            filters={[
                <SelectInput key="role_id" source="role_id" label="役職" choices={roleChoices} emptyValue={null} emptyText="すべて" alwaysOn={false} />,
                <ReferenceInput key="member_id" source="member_id" reference="members" label="メンバー" alwaysOn={false}>
                    <SelectInput optionText="name" emptyValue={null} emptyText="すべて" />
                </ReferenceInput>,
                <DateInput key="from" source="from" label="期間 From" alwaysOn={false} />,
                <DateInput key="to" source="to" label="期間 To" alwaysOn={false} />,
            ]}
        >
            <Datagrid bulkActionButtons={false}>
                <TextField source="member_name" label="メンバー" />
                <TextField source="role_name" label="役職" />
                <DateField source="term_start" label="開始日" locales="ja-JP" />
                <DateField source="term_end" label="終了日" locales="ja-JP" emptyText="—" />
                <FunctionField label="状態" render={(r) => <StatusField record={r} />} />
            </Datagrid>
        </List>
    );
}
