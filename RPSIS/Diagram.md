classDiagram
direction BT
class attributes_values
class brigade_types
class brigades
class delay_reasons
class departments
class departments_headmasters
class employee
class employee_professions
class inspection_schedule
class locomotive_tech_brigades
class locomotives
class locomotives_tech_maintenance
class luggage
class med_check
class passengers
class professions
class professions_attributes
class route_types
class routes
class tech_maintenance
class ticket_offices
class ticket_refunds
class ticket_statuses
class tickets
class train_delays
class train_schedule
class train_types

attributes_values  -->  employee : employee_id:id
attributes_values  -->  professions_attributes : profession_attribute_id:id
brigades  -->  brigade_types : brigade_type:id
departments_headmasters  -->  departments : department_id:id
departments_headmasters  -->  employee : headmaster_id:id
employee  -->  brigades : brigade_id:id
employee  -->  departments : department_id:id
employee_professions  -->  employee : employee_id:id
employee_professions  -->  professions : profession_id:id
locomotive_tech_brigades  -->  brigades : brigade_id:id
locomotive_tech_brigades  -->  locomotives : locomotive_id:id
locomotives  -->  brigades : locomotive_brigade_id:id
locomotives_tech_maintenance  -->  locomotives : locomotive_id:id
locomotives_tech_maintenance  -->  tech_maintenance : tech_id:id
luggage  -->  passengers : passenger_id:id
med_check  -->  employee : employee_id:id
professions_attributes  -->  professions : profession_id:id
routes  -->  route_types : route_type:id
tech_maintenance  -->  inspection_schedule : inspection_schedule_id:id
ticket_refunds  -->  tickets : ticket_id:id
tickets  -->  locomotives : train_id:id
tickets  -->  passengers : passenger_id:id
tickets  -->  ticket_offices : ticket_office_id:id
tickets  -->  ticket_statuses : status:id
train_delays  -->  delay_reasons : delay_reason_id:id
train_delays  -->  train_schedule : train_schedule_id:id
train_schedule  -->  locomotives : train_id:id
train_schedule  -->  routes : route_id:id
train_schedule  -->  train_types : train_type_id:id
