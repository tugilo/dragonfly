import React from 'react';
import { createRoot } from 'react-dom/client';
import { Admin, Resource } from 'react-admin';
import { dragonflyDataProvider } from './dataProvider';
import { religoTheme } from './theme/religoTheme';
import DragonFlyBoard from './pages/DragonFlyBoard';
import Dashboard from './pages/Dashboard';
import { ReligoLayout } from './ReligoLayout';
import { MembersList } from './pages/MembersList';
import { MemberShow } from './pages/MemberShow';
import { MeetingsList } from './pages/MeetingsList';
import { OneToOnesList, OneToOnesCreate } from './pages/OneToOnesList';
import { RoleHistoryList } from './pages/RoleHistoryList';
import { CategoriesList } from './pages/CategoriesList';
import { CategoriesCreate } from './pages/CategoriesCreate';
import { CategoriesEdit } from './pages/CategoriesEdit';
import { RolesList } from './pages/RolesList';
import { RolesCreate } from './pages/RolesCreate';
import { RolesEdit } from './pages/RolesEdit';

const root = document.getElementById('admin-root');
if (root) {
    createRoot(root).render(
        <Admin
            dataProvider={dragonflyDataProvider}
            layout={ReligoLayout}
            dashboard={Dashboard}
            theme={religoTheme}
        >
            <Resource name="connections" list={DragonFlyBoard} options={{ label: 'Connections' }} />
            <Resource name="members" list={MembersList} show={MemberShow} options={{ label: 'Members' }} />
            <Resource name="meetings" list={MeetingsList} options={{ label: 'Meetings' }} />
            <Resource name="one-to-ones" list={OneToOnesList} create={OneToOnesCreate} options={{ label: '1 to 1' }} />
            <Resource name="role-history" list={RoleHistoryList} options={{ label: 'Role History' }} />
            <Resource name="categories" list={CategoriesList} create={CategoriesCreate} edit={CategoriesEdit} options={{ label: 'Categories' }} />
            <Resource name="roles" list={RolesList} create={RolesCreate} edit={RolesEdit} options={{ label: 'Roles' }} />
        </Admin>
    );
}
