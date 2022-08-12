import { NgModule } from '@angular/core';
// routing functionality
import { RouterModule, Routes } from '@angular/router';
import { CustomComponent } from './custom/custom.component';
import { ExtensionComponent} from './extension/extension.component'
import { DashboardComponent} from './dashboard/dashboard.component'
import { CustomPropertyComponent } from './custom-property/custom-property.component';

// routes from /heroes that leads to hereos
const routes: Routes = [
  { path: 'extension', component: ExtensionComponent},
  { path: 'custom', component: CustomComponent},
  { path: 'customproperty', component: CustomPropertyComponent},
  { path: 'dashboard', component: DashboardComponent},
  // default path
  { path: '', redirectTo: '/extension', pathMatch: 'full'},
];

// make routing with the roots as configuration
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})

export class AppRoutingModule { }