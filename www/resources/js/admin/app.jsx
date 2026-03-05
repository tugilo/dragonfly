import React from 'react';
import { createRoot } from 'react-dom/client';
import { Admin, Resource, CustomRoutes } from 'react-admin';
import { Route } from 'react-router-dom';
import { dragonflyDataProvider } from './dataProvider';
import DragonFlyBoard from './pages/DragonFlyBoard';
import Dashboard from './pages/Dashboard';
import { ReligoLayout } from './ReligoLayout';
import { MembersList } from './pages/MembersList';
import { MeetingsList } from './pages/MeetingsList';
import { OneToOnesList, OneToOnesCreate } from './pages/OneToOnesList';
import { RoleHistoryList } from './pages/RoleHistoryList';
import CategoriesPage from './pages/CategoriesPage';
import RolesPage from './pages/RolesPage';

const root = document.getElementById('admin-root');
if (root) {
    createRoot(root).render(
        <Admin
            dataProvider={dragonflyDataProvider}
            layout={ReligoLayout}
            dashboard={Dashboard}
        >
            <Resource name="connections" list={DragonFlyBoard} options={{ label: 'Connections' }} />
            <Resource name="members" list={MembersList} options={{ label: 'Members' }} />
            <Resource name="meetings" list={MeetingsList} options={{ label: 'Meetings' }} />
            <Resource name="one-to-ones" list={OneToOnesList} create={OneToOnesCreate} options={{ label: '1 to 1' }} />
            <Resource name="role-history" list={RoleHistoryList} options={{ label: 'Role History' }} />
            <CustomRoutes>
                <Route path="/settings/categories" element={<CategoriesPage />} />
                <Route path="/settings/roles" element={<RolesPage />} />
            </CustomRoutes>
        </Admin>
    );
}
