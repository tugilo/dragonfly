import React from 'react';
import { Route } from 'react-router-dom';
import { createRoot } from 'react-dom/client';
import { Admin, Resource, CustomRoutes } from 'react-admin';
import { dragonflyDataProvider } from './dataProvider';
import { religoTheme } from './theme/religoTheme';
import DragonFlyBoard from './pages/DragonFlyBoard';
import Dashboard from './pages/Dashboard';
import ReligoSettings from './pages/ReligoSettings';
import MemberMerge from './pages/MemberMerge';
import ZoomImport from './pages/ZoomImport';
import { ReligoLayout } from './ReligoLayout';
import { ReligoOwnerProvider } from './ReligoOwnerContext';
import { ReligoLogin } from './pages/ReligoLogin';
import { religoAuthProvider } from './authProvider';
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
import SonaeShell from './sonae/SonaeShell';
import SonaeDashboard from './pages/sonae/SonaeDashboard';
import SonaeMembersPage from './pages/sonae/SonaeMembersPage';
import SonaeLinePage from './pages/sonae/SonaeLinePage';
import SonaeTrainingPage from './pages/sonae/SonaeTrainingPage';
import SonaeJmaPage from './pages/sonae/SonaeJmaPage';
import SonaeAlertSettingsPage from './pages/sonae/SonaeAlertSettingsPage';
import ShizuokaOutreachTool from './pages/ShizuokaOutreachTool';

const root = document.getElementById('admin-root');
if (root) {
    createRoot(root).render(
        <ReligoOwnerProvider>
        <Admin
            authProvider={religoAuthProvider}
            loginPage={ReligoLogin}
            dataProvider={dragonflyDataProvider}
            layout={ReligoLayout}
            dashboard={Dashboard}
            theme={religoTheme}
        >
            {(permissions) => {
                const isAdmin = permissions === 'chapter_admin';
                return (
                    <>
                        <CustomRoutes>
                            <Route path="/settings" element={<ReligoSettings />} />
                            <Route path="/zoom-import" element={<ZoomImport />} />
                            <Route path="/tools/shizuoka-outreach" element={<ShizuokaOutreachTool />} />
                            {isAdmin && <Route path="/member-merge" element={<MemberMerge />} />}
                            {isAdmin && (
                                <Route path="/sonae/*" element={<SonaeShell />}>
                                    <Route index element={<SonaeDashboard />} />
                                    <Route path="members" element={<SonaeMembersPage />} />
                                    <Route path="line" element={<SonaeLinePage />} />
                                    <Route path="training" element={<SonaeTrainingPage />} />
                                    <Route path="jma" element={<SonaeJmaPage />} />
                                    <Route path="alert-settings" element={<SonaeAlertSettingsPage />} />
                                </Route>
                            )}
                        </CustomRoutes>
                        <Resource name="connections" list={DragonFlyBoard} options={{ label: 'Connections' }} />
                        <Resource
                            name="members"
                            list={MembersList}
                            show={MemberShow}
                            edit={isAdmin ? MemberEdit : undefined}
                            options={{ label: 'Members' }}
                        />
                        <Resource name="meetings" list={MeetingsList} options={{ label: 'Meetings' }} />
                        <Resource name="one-to-ones" list={OneToOnesList} create={OneToOnesCreate} edit={OneToOnesEdit} options={{ label: '1 to 1' }} />
                        <Resource name="role-history" list={RoleHistoryList} options={{ label: 'Role History' }} />
                        {isAdmin && (
                            <Resource name="categories" list={CategoriesList} create={CategoriesCreate} edit={CategoriesEdit} options={{ label: 'Categories' }} />
                        )}
                        {isAdmin && (
                            <Resource name="roles" list={RolesList} create={RolesCreate} edit={RolesEdit} options={{ label: 'Roles' }} />
                        )}
                    </>
                );
            }}
        </Admin>
        </ReligoOwnerProvider>
    );
}
