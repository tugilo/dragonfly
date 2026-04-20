import React from 'react';
import { createRoot } from 'react-dom/client';
import { Route } from 'react-router-dom';
import { Admin, Resource, CustomRoutes } from 'react-admin';
import { dragonflyDataProvider } from './dataProvider';
import { religoTheme } from './theme/religoTheme';
import DragonFlyBoard from './pages/DragonFlyBoard';
import Dashboard from './pages/Dashboard';
import ReligoSettings from './pages/ReligoSettings';
import MemberMerge from './pages/MemberMerge';
import { ReligoLayout } from './ReligoLayout';
import { ReligoOwnerProvider } from './ReligoOwnerContext';
import { MembersList } from './pages/MembersList';
import { MemberShow } from './pages/MemberShow';
import { MemberEdit } from './pages/MemberEdit';
import { MeetingsList } from './pages/MeetingsList';
import { OneToOnesList } from './pages/OneToOnesList';
import { OneToOnesCreate } from './pages/OneToOnesCreate';
import { OneToOnesEdit } from './pages/OneToOnesEdit';
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
        <ReligoOwnerProvider>
        <Admin
            dataProvider={dragonflyDataProvider}
            layout={ReligoLayout}
            dashboard={Dashboard}
            theme={religoTheme}
        >
            <CustomRoutes>
                <Route path="/settings" element={<ReligoSettings />} />
                <Route path="/member-merge" element={<MemberMerge />} />
            </CustomRoutes>
            <Resource name="connections" list={DragonFlyBoard} options={{ label: 'Connections' }} />
            <Resource name="members" list={MembersList} show={MemberShow} edit={MemberEdit} options={{ label: 'Members' }} />
            <Resource name="meetings" list={MeetingsList} options={{ label: 'Meetings' }} />
            <Resource name="one-to-ones" list={OneToOnesList} create={OneToOnesCreate} edit={OneToOnesEdit} options={{ label: '1 to 1' }} />
            <Resource name="role-history" list={RoleHistoryList} options={{ label: 'Role History' }} />
            <Resource name="categories" list={CategoriesList} create={CategoriesCreate} edit={CategoriesEdit} options={{ label: 'Categories' }} />
            <Resource name="roles" list={RolesList} create={RolesCreate} edit={RolesEdit} options={{ label: 'Roles' }} />
        </Admin>
        </ReligoOwnerProvider>
    );
}
