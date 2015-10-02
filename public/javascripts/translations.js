var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":{"one":"is too long (maximum is 1 character)","other":"is too long (maximum is %{count} characters)"},"too_short":{"one":"is too short (minimum is 1 character)","other":"is too short (minimum is %{count} characters)"},"wrong_length":{"one":"is the wrong length (should be 1 character)","other":"is the wrong length (should be %{count} characters)"},"not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken","carrierwave_processing_error":"failed to be processed","carrierwave_integrity_error":"is not of an allowed file type","carrierwave_download_error":"could not be downloaded","extension_white_list_error":"You are not allowed to upload %{extension} files, allowed types: %{allowed_types}","extension_black_list_error":"You are not allowed to upload %{extension} files, prohibited types: %{prohibited_types}","rmagick_processing_error":"Failed to manipulate with rmagick, maybe it is not an image? Original Error: %{e}","mime_types_processing_error":"Failed to process file with MIME::Types, maybe not valid content-type? Original Error: %{e}","mini_magick_processing_error":"Failed to manipulate with MiniMagick, maybe it is not an image? Original Error: %{e}","already_confirmed":"was already confirmed, please try signing in","confirmation_period_expired":"needs to be confirmed within %{period}, please request a new one","expired":"has expired, please request a new one","not_found":"not found","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"}}},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}},"models":{"content/models/lobject":"Resource"},"attributes":{"content/models/grade":{"grade":"Name"},"content/models/lobject":{"lobject_downloads":"Downloadable resources","related_lobjects":"Related materials","status":"Status"},"content/models/lobject_child":{"child_id":"Learning Object"},"content/models/lobject_collection":{"lobject":"Root Learning Object","lobject_collection_type":"Collection Type"},"content/models/url":{"url":"URL"}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"flash":{"actions":{"create":{"notice":"%{resource_name} was successfully created."},"update":{"notice":"%{resource_name} was successfully updated."},"destroy":{"notice":"%{resource_name} was successfully destroyed.","alert":"%{resource_name} could not be destroyed."}}},"ransack":{"search":"search","predicate":"predicate","and":"and","or":"or","any":"any","all":"all","combinator":"combinator","attribute":"attribute","value":"value","condition":"condition","sort":"sort","asc":"ascending","desc":"descending","predicates":{"eq":"equals","eq_any":"equals any","eq_all":"equals all","not_eq":"not equal to","not_eq_any":"not equal to any","not_eq_all":"not equal to all","matches":"matches","matches_any":"matches any","matches_all":"matches all","does_not_match":"doesn't match","does_not_match_any":"doesn't match any","does_not_match_all":"doesn't match all","lt":"less than","lt_any":"less than any","lt_all":"less than all","lteq":"less than or equal to","lteq_any":"less than or equal to any","lteq_all":"less than or equal to all","gt":"greater than","gt_any":"greater than any","gt_all":"greater than all","gteq":"greater than or equal to","gteq_any":"greater than or equal to any","gteq_all":"greater than or equal to all","in":"in","in_any":"in any","in_all":"in all","not_in":"not in","not_in_any":"not in any","not_in_all":"not in all","cont":"contains","cont_any":"contains any","cont_all":"contains all","not_cont":"doesn't contain","not_cont_any":"doesn't contain any","not_cont_all":"doesn't contain all","start":"starts with","start_any":"starts with any","start_all":"starts with all","not_start":"doesn't start with","not_start_any":"doesn't start with any","not_start_all":"doesn't start with all","end":"ends with","end_any":"ends with any","end_all":"ends with all","not_end":"doesn't end with","not_end_any":"doesn't end with any","not_end_all":"doesn't end with all","true":"is true","false":"is false","present":"is present","blank":"is blank","null":"is null","not_null":"is not null"}},"will_paginate":{"previous_label":"&#8592; Previous","next_label":"Next &#8594;","page_gap":"&hellip;","page_entries_info":{"single_page":{"zero":"No %{model} found","one":"Displaying 1 %{model}","other":"Displaying all %{count} %{model}"},"single_page_html":{"zero":"No %{model} found","one":"Displaying <b>1</b> %{model}","other":"Displaying <b>all&nbsp;%{count}</b> %{model}"},"multi_page":"Displaying %{model} %{from} - %{to} of %{count} in total","multi_page_html":"Displaying %{model} <b>%{from}&nbsp;-&nbsp;%{to}</b> of <b>%{count}</b> in total"}},"ckeditor":{"page_title":"CKEditor Files Manager","confirm_delete":"Delete file?","buttons":{"cancel":"Cancel","upload":"Upload","delete":"Delete","next":"Next"}},"devise":{"confirmations":{"confirmed":"Your email address has been successfully confirmed.","send_instructions":"You will receive an email with instructions for how to confirm your email address in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes."},"failure":{"already_authenticated":"You are already signed in.","inactive":"Your account is not activated yet.","invalid":"Invalid %{authentication_keys} or password.","locked":"Your account is locked.","last_attempt":"You have one more attempt before your account is locked.","not_found_in_database":"Invalid %{authentication_keys} or password.","timeout":"Your session expired. Please sign in again to continue.","unauthenticated":"You need to sign in or sign up before continuing.","unconfirmed":"You have to confirm your email address before continuing."},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock instructions"}},"omniauth_callbacks":{"failure":"Could not authenticate you from %{kind} because \"%{reason}\".","success":"Successfully authenticated from %{kind} account."},"passwords":{"no_token":"You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.","send_instructions":"You will receive an email with instructions on how to reset your password in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.","updated":"Your password has been changed successfully. You are now signed in.","updated_not_active":"Your password has been changed successfully."},"registrations":{"destroyed":"Bye! Your account has been successfully cancelled. We hope to see you again soon.","signed_up":"Welcome! You have signed up successfully.","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.","updated":"Your account has been updated successfully."},"sessions":{"signed_in":"Signed in successfully.","signed_out":"Signed out successfully.","already_signed_out":"Signed out successfully."},"unlocks":{"send_instructions":"You will receive an email with instructions for how to unlock your account in a few minutes.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.","unlocked":"Your account has been unlocked successfully. Please sign in to continue."}},"lt":{"admin":{"welcome":{"index":{"edit_synonyms":"Edit synonyms"}},"synonyms":{"edit":{"page_title":"Edit synonyms","warning":"Warning: this operation will shut down the Elasticsearch index for a few seconds."},"update":{"success":"Synonyms updated successfully"}}}},"layouts":{"unbounded":{"admin":"Administration","tos":"Terms of Service"},"unbounded_admin":{"admin":"Administration"}},"lobject_statuses":{"active":"Active","hidden":"Hidden"},"resource_types":{"video":"Video","resource":"Resource"},"nav":{"curriculum":"Curriculum","professional_development":"Professional Development","news":"News","about":"About"},"resources_count":{"one":"resource","other":"resources"},"unbounded":{"admin":{"collection_types":{"create":{"success":"Collection Type created successfully."},"destroy":{"success":"Collection Type deleted successfully."},"edit":{"page_title":"Edit Collection Type #%{collection_type_id}"},"index":{"new_collection_type":"Add Collection Type","page_title":"Collection Types"},"new":{"page_title":"New Collection Type"},"update":{"success":"Collection Type updated successfully."}},"collections":{"create":{"success":"Learning Objects Collection created successfully."},"destroy":{"success":"Learning Objects Collection #%{collection_id} was deleted successfully."},"edit":{"add_node":"Add node","manage_lobjects":"Manage Learning Objects","page_title":"Edit Learning Objects Collection #%{collection_id}"},"editable_tree":{"add_node":"Add node","delete_subtree":"Delete subtree","restore_subtree":"Restore subtree"},"index":{"items_count":"Items count","new_collection":"Add Learning Objects Collection","page_title":"Learning Objects Collections"},"new":{"page_title":"New Learning Objects Collection"},"show":{"page_title":"Learning Objects Collection #%{collection_id}"},"update":{"success":"Learning Objects Collection was updated successfully."}},"lobject_bulk_edits":{"create":{"success":"%{count} %{resources_count} updated successfully."},"new":{"no_resources":"No resources were selected.","page_title":"Edit Tags"}},"lobject_children":{"create":{"success":"New Node added into Collection successfully."}},"lobjects":{"destroy":{"success":"Learning Object #%{lobject_id} was deleted successfully."},"edit":{"page_title":"Edit Learning Object #%{lobject_id}"},"form":{"add_download":"Add Downloadable Resource","create_alignment":"Create Alignment","create_grade":"Create Grade","create_resource_type":"Create Resource Type","create_subject":"Create Subject","create_topic":"Create Topic"},"index":{"grade_levels":"Grade Levels","new_lobject":"Add Resource","page_title":"Content Administration","resource":"Resource","resource_types":"Resource Types","standards":"Standards","status":"Status","subjects":"Subjects"},"new":{"page_title":"New Learning Object"},"search_form":{"grades":"Grades","resource_types":"Resource Types","standards":"Standards","subjects":"Subjects"}},"pages":{"create":{"success":"Page created successfully."},"destroy":{"success":"Page deleted successfully."},"edit":{"page_title":"Edit Page #%{page_id}"},"index":{"new_page":"Add Page","page_title":"Pages"},"new":{"page_title":"New Page"},"update":{"success":"Page updated successfully."}},"welcome":{"index":{"collection_types":"Collection Types","collections":"Collections","pages":"Pages","resources":"Resources"}}},"lobjects":{"nav":{"next_lesson":"Next LESSON","next_module":"Next MODULE","next_unit":"Next UNIT","previous_lesson":"Previous LESSON","previous_module":"Previous MODULE","previous_unit":"Previous UNIT"},"sidebar_lr_nav":{"previous_link":"Previous %{title}","next_link":"Next %{title}"}},"browser":"Unbounded Content Browser","curriculum":{"ela":"English Language Arts","math":"Mathematics","ela_module_label":"Module","math_module_label":"Module","ela_unit_label":"Unit","math_unit_label":"Topic","ela_lesson_label":"Lesson","math_lesson_label":"Lesson","unit_title":"Unit %{idx}","module_title":"Module %{idx}"},"title":{"logo":"Unbounded","subscribe":"Stay connected","active":"Document status","age_range":"Age range","age_ranges":"Age ranges","alignment":"Alignment","alignments":"Alignments","grade":"Grade","grades":"Grades","identity":"Identity","identities":"Identities","language":"Language","languages":"Languages","resource_type":"Resource type","resource_types":"Resource types","subject":"Subject","subjects":"Subjects","standard":"Standard","standards":"Standards","status":"Document status","sources":{"engageny":"Document status"},"topic":"Topic","topics":"Topics"},"content_type":{"application/zip":"zip","application/pdf":"pdf","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":"openoffice spreadsheet","application/vnd.ms-excel":"excel","application/vnd.openxmlformats-officedocument.presentationml.presentation":"openoffice presentation","application/msword":"doc","application/vnd.openxmlformats-officedocument.wordprocessingml.document":"openoffice document","application/vnd.ms-powerpoint":"powerpoint"}},"ui":{"actions":"Actions","add":"Add","all":"All","are_you_sure":"Are you sure?","close":"Close","delete":"Delete","edit":"Edit","loading":"Loading","remove":"Remove","save":"Save","subscribe":"Subscribe","search":"Search","open_lesson":"Open this Lesson"},"home_page":{"curriculum_html":"We offer teachers a comprehensive Standards&ndash;aligned library of free education resources, built on years of experience creating widely adopted OER curriculum and professional development materials.\n","professional_development_html":"We help teachers make better instructional decisions by providing immersive training and free standards&ndash;aligned resources for their students.\n","about_html":"We are dedicated to a singular goal: helping fellow educators help their students to achieve learning goals set by higher standards\n","slogan":"Strong schools, strong students","tagline":"Educators getting smarter together about high standards"},"curriculum_page":{"search_form":{"grade_label":"What is the grade?","disabilities_label":"What % of kids have disabilities?","time_label":"What is the length of time you are hoping to fill?","standard_label":"Is there a perticular standard you want to teach?","subject_label":"What is the subject?","ell_label":"What % of your students are ELL?","ell_level_label":"What level are your ELL students in:\n","text_label":"Is there a specific text you wnat to use?"}},"lesson_page":{"instructional_resources":"Instructional resources","related_resources":"Related professional development resources"},"footer":{"copyright_html":"Copyright &copy; UNBOUNDED ltd.","address_html":"123 Main Street, 12th fl, New York NY 10003\n","phone_html":"(888)123-4567","rights_html":"All rights reserved.","search":"Search"},"simple_form":{"yes":"Yes","no":"No","required":{"text":"required","mark":"*"},"error_notification":{"default_message":"Please review the problems below:"}}},"es":{"ransack":{"search":"buscar","predicate":"predicado","and":"y","or":"o","any":"cualquier","all":"todos","combinator":"combinado","attribute":"atributo","value":"valor","condition":"condición","sort":"ordernar","asc":"ascendente","desc":"descendente","predicates":{"eq":"es igual a","eq_any":"es igual a cualquier","eq_all":"es igual a todos","not_eq":"no es igual a","not_eq_any":"no es igual a cualquier","not_eq_all":"no es iguala todos","matches":"coincidir","matches_any":"coincidir a cualquier","matches_all":"coincidir a todos","does_not_match":"no coincide","does_not_match_any":"no coincide con ninguna","does_not_match_all":"no coincide con todos","lt":"menor que","lt_any":"menor que cualquier","lt_all":"menor o igual a","lteq":"menor que o igual a","lteq_any":"menor o igual a cualquier","lteq_all":"menor o igual a todos","gt":"mayor que","gt_any":"mayor que cualquier","gt_all":"mayor que todos","gteq":"mayor que o igual a","gteq_any":"mayor que o igual a cualquier","gteq_all":"mayor que o igual a todos","in":"en","in_any":"en cualquier","in_all":"en todos","not_in":"no en","not_in_any":"no en cualquier","not_in_all":"no en todos","cont":"contiene","cont_any":"contiene cualquier","cont_all":"contiene todos","not_cont":"no contiene","not_cont_any":"no contiene ninguna","not_cont_all":"no contiene toda","start":"comienza con","start_any":"comienza con cualquier","start_all":"comienza con toda","not_start":"no inicia con","not_start_any":"no comienza con cualquier","not_start_all":"no inicia con toda","end":"termina con","end_any":"termina con cualquier","end_all":"termina con todo","not_end":"no termina con","not_end_any":"no termina con cualquier","not_end_all":"no termina con todo","true":"es verdadero","false":"es falso","present":"es presente","blank":"está en blanco","null":"es nula","not_null":"no es nula"}},"ckeditor":{"page_title":"Administrador de Archivos CKEditor","confirm_delete":"¿Borrar archivo?","buttons":{"cancel":"Cancelar","upload":"Subir","delete":"Borrar","next":"Next"}}},"fr":{"ransack":{"search":"recherche","predicate":"prédicat","and":"et","or":"ou","any":"au moins un","all":"tous","combinator":"combinateur","attribute":"attribut","value":"valeur","condition":"condition","sort":"tri","asc":"ascendant","desc":"descendant","predicates":{"eq":"égal à","eq_any":"égal à au moins un","eq_all":"égal à tous","not_eq":"différent de","not_eq_any":"différent d'au moins un","not_eq_all":"différent de tous","matches":"correspond à","matches_any":"correspond à au moins un","matches_all":"correspond à tous","does_not_match":"ne correspond pas à","does_not_match_any":"ne correspond pas à au moins un","does_not_match_all":"ne correspond à aucun","lt":"inférieur à","lt_any":"inférieur à au moins un","lt_all":"inférieur à tous","lteq":"inférieur ou égal à","lteq_any":"inférieur ou égal à au moins un","lteq_all":"inférieur ou égal à tous","gt":"supérieur à","gt_any":"supérieur à au moins un","gt_all":"supérieur à tous","gteq":"supérieur ou égal à","gteq_any":"supérieur ou égal à au moins un","gteq_all":"supérieur ou égal à tous","in":"inclus dans","in_any":"inclus dans au moins un","in_all":"inclus dans tous","not_in":"non inclus dans","not_in_any":"non inclus dans au moins un","not_in_all":"non inclus dans tous","cont":"contient","cont_any":"contient au moins un","cont_all":"contient tous","not_cont":"ne contient pas","not_cont_any":"ne contient pas au moins un","not_cont_all":"ne contient pas tous","start":"commence par","start_any":"commence par au moins un","start_all":"commence par tous","not_start":"ne commence pas par","not_start_any":"ne commence pas par au moins un","not_start_all":"ne commence pas par tous","end":"finit par","end_any":"finit par au moins un","end_all":"finit par tous","not_end":"ne finit pas par","not_end_any":"ne finit pas par au moins un","not_end_all":"ne finit pas par tous","true":"est vrai","false":"est faux","present":"est présent","blank":"est blanc","null":"est null","not_null":"n'est pas null"}},"ckeditor":{"page_title":"CKEditor - Gestionnaire de fichiers","confirm_delete":"Supprimer le fichier ?","buttons":{"cancel":"Annuler","upload":"Ajouter","delete":"Supprimer","next":"Next"}}},"hu":{"ransack":{"search":"keresés","predicate":"állítás","and":"és","or":"vagy","any":"bármely","all":"mindegyik","combinator":"combinator","attribute":"attribute","value":"érték","condition":"feltétel","sort":"rendezés","asc":"növekvő","desc":"csökkenő","predicates":{"eq":"egyenlő","eq_any":"bármelyikkel egyenlő","eq_all":"minddel egyenlő","not_eq":"nem egyenlő","not_eq_any":"nem egyenlő bármelyikkel","not_eq_all":"nem egyenlő egyikkel sem","matches":"egyezik","matches_any":"bármelyikkel egyezik","matches_all":"minddel egyezik","does_not_match":"nem egyezik","does_not_match_any":"nem egyezik semelyikkel","does_not_match_all":"nem egyezik az összessel","lt":"kisebb, mint","lt_any":"bármelyiknél kisebb","lt_all":"mindegyiknél kisebb","lteq":"kisebb vagy egyenlő, mint","lteq_any":"bármelyiknél kisebb vagy egyenlő","lteq_all":"mindegyiknél kisebb vagy egyenlő","gt":"nagyobb, mint","gt_any":"bármelyiknél nagyobb","gt_all":"mindegyiknél nagyobb","gteq":"nagyobb vagy egyenlő, mint","gteq_any":"bármelyiknél nagyobb vagy egyenlő","gteq_all":"mindegyiknél nagyobb vagy egyenlő","in":"értéke","in_any":"értéke bármelyik","in_all":"értéke mindegyik","not_in":"nem ez az értéke","not_in_any":"értéke egyik sem","not_in_all":"értéke nem ezek az elemek","cont":"tartalmazza","cont_any":"bármelyiket tartalmazza","cont_all":"mindet tartalmazza","not_cont":"nem tartalmazza","not_cont_any":"egyiket sem tartalmazza","not_cont_all":"nem tartalmazza mindet","start":"így kezdődik","start_any":"bármelyikkel kezdődik","start_all":"ezekkel kezdődik","not_start":"nem így kezdődik","not_start_any":"nem ezek egyikével kezdődik","not_start_all":"nem ezekkel kezdődik","end":"így végződik","end_any":"bármelyikkel végződik","end_all":"ezekkel végződik","not_end":"nem úgy végződik","not_end_any":"nem ezek egyikével végződik","not_end_all":"nem ezekkel végződik","true":"igaz","false":"hamis","present":"létezik","blank":"üres","null":"null","not_null":"nem null"}},"ckeditor":{"page_title":"CKEditor fájlkezelő","confirm_delete":"Biztosan töröljük a fájlt?","buttons":{"cancel":"Mégsem","upload":"Feltöltés","delete":"Törlés","next":"Next"}}},"nl":{"ransack":{"search":"zoeken","predicate":"eigenschap","and":"en","or":"of","any":"enig","all":"alle","combinator":"combinator","attribute":"attribuut","value":"waarde","condition":"conditie","sort":"sorteren","asc":"oplopend","desc":"aflopend","predicates":{"eq":"gelijk","eq_any":"gelijk enig","eq_all":"gelijk alle","not_eq":"niet gelijk aan","not_eq_any":"niet gelijk aan enig","not_eq_all":"niet gelijk aan alle","matches":"evenaart","matches_any":"evenaart enig","matches_all":"evenaart alle","does_not_match":"evenaart niet","does_not_match_any":"evenaart niet voor enig","does_not_match_all":"evenaart niet voor alle","lt":"kleiner dan","lt_any":"kleiner dan enig","lt_all":"kleiner dan alle","lteq":"kleiner dan of gelijk aan","lteq_any":"kleiner dan of gelijk aan enig","lteq_all":"kleiner dan of gelijk aan alle","gt":"groter dan","gt_any":"groter dan enig","gt_all":"groter dan alle","gteq":"groter dan or equal to","gteq_any":"groter dan or equal to enig","gteq_all":"groter dan or equal to alle","in":"in","in_any":"in enig","in_all":"in alle","not_in":"niet in","not_in_any":"niet in enig","not_in_all":"niet in alle","cont":"bevat","cont_any":"bevat enig","cont_all":"bevat alle","not_cont":"bevat niet","not_cont_any":"bevat niet enig","not_cont_all":"bevat niet alle","start":"start met","start_any":"start met enig","start_all":"start met alle","not_start":"start niet met","not_start_any":"start niet met enig","not_start_all":"start niet met alle","end":"eindigt met","end_any":"eindigt met enig","end_all":"eindigt met alle","not_end":"eindigt niet met","not_end_any":"eindigt niet met enig","not_end_all":"eindigt niet met alle","true":"is waar","false":"is niet waar","present":"is present","blank":"is afwezig","null":"is null","not_null":"is niet null"}},"ckeditor":{"page_title":"CKEditor Files Manager","confirm_delete":"Delete file?","buttons":{"cancel":"Cancel","upload":"Upload","delete":"Delete","next":"Next"}}},"cs":{"ransack":{"search":"vyhledávání","predicate":"predikát","and":"a","or":"nebo","any":"kteroukoliv","all":"každou","combinator":"kombinátor","attribute":"atribut","value":"hodnota","condition":"podmínka","sort":"řazení","asc":"vzestupné","desc":"sestupné","predicates":{"eq":"rovno","eq_any":"rovno kterékoliv","eq_all":"rovno všem","not_eq":"nerovno","not_eq_any":"nerovno kterékoliv","not_eq_all":"nerovno všem","matches":"odpovídá","matches_any":"odpovídá kterékoliv","matches_all":"odpovídá všem","does_not_match":"neodpovídá","does_not_match_any":"neodpovídá kterékoliv","does_not_match_all":"neodpovídá všem","lt":"menší než","lt_any":"menší než kterákoliv","lt_all":"menší než všechny","lteq":"menší nebo rovno než","lteq_any":"menší nebo rovno než kterákoliv","lteq_all":"menší nebo rovno než všechny","gt":"větší než","gt_any":"větší než kterákoliv","gt_all":"větší než všechny","gteq":"větší nebo rovno než","gteq_any":"větší nebo rovno než kterákoliv","gteq_all":"větší nebo rovno než všechny","in":"v","in_any":"v kterékoliv","in_all":"ve všech","not_in":"není v","not_in_any":"není v kterékoliv","not_in_all":"není ve všech","cont":"obsahuje","cont_any":"obsahuje kterékoliv","cont_all":"obsahuje všechny","not_cont":"neobsahuje","not_cont_any":"neobsahuje kteroukoliv","not_cont_all":"neobsahuje všechny","start":"začíná s","start_any":"začíná s kteroukoliv","start_all":"začíná se všemi","not_start":"nezačíná s","not_start_any":"nezačíná s kteroukoliv","not_start_all":"nezačíná se všemi","end":"končí s","end_any":"končí s kteroukoliv","end_all":"končí se všemi","not_end":"nekončí s","not_end_any":"nekončí s kteroukoliv","not_end_all":"nekončí se všemi","true":"je pravdivé","false":"není pravdivé","present":"je vyplněné","blank":"je prázdné","null":"je null","not_null":"není null"}},"ckeditor":{"page_title":"CKEditor Správce souborů","confirm_delete":"Smazat soubor ?","buttons":{"cancel":"Zrušit","upload":"Nahrát","delete":"Smazat","next":"Next"}}},"ro":{"ransack":{"search":"caută","predicate":"predicat","and":"și","or":"sau","any":"oricare","all":"toate","combinator":"combinator","attribute":"atribut","value":"valoare","condition":"condiție","sort":"sortează","asc":"crescător","desc":"descrescător","predicates":{"eq":"egal cu","eq_any":"egal cu unul din","eq_all":"egal cu toate","not_eq":"diferit de","not_eq_any":"diferit de toate","not_eq_all":"nu este egal cu toate","matches":"corespunde","matches_any":"corespunde cu unul din","matches_all":"corespunde cu toate","does_not_match":"nu corespunde","does_not_match_any":"nu corespunde cu nici un","does_not_match_all":"nu corespunde cu toate","lt":"mai mic de","lt_any":"mai mic decât cel puțin unul din","lt_all":"mai mic decât toate","lteq":"mai mic sau egal decât","lteq_any":"mai mic sau egal decât cel puțin unul din","lteq_all":"mai mic sau egal decât toate","gt":"mai mare de","gt_any":"mai mare decât cel puțin unul din","gt_all":"mai mare decât toate","gteq":"mai mare sau egal decât","gteq_any":"mai mare sau egal decât cel puțin unul din","gteq_all":"mai mare sau egal decât toate","in":"inclus în","in_any":"inclus într-unul din","in_all":"inclus în toate","not_in":"nu este inclus în","not_in_any":"nu este inclus într-unul din","not_in_all":"nu este inclus în toate","cont":"conține","cont_any":"conține unul din","cont_all":"conține toate","not_cont":"nu conține","not_cont_any":"nu conține unul din","not_cont_all":"nu conține toate","start":"începe cu","start_any":"începe cu unul din","start_all":"începe cu toate","not_start":"nu începe","not_start_any":"nu începe cu unul din","not_start_all":"nu începe cu toate","end":"se termină cu","end_any":"se termină cu unul din","end_all":"se termină cu toate","not_end":"nu se termină cu","not_end_any":"nu se termină cu unul din","not_end_all":"nu se termină cu toate","true":"este adevărat","false":"este fals","present":"este prezent","blank":"este gol","null":"este nul","not_null":"nu este nul"}}},"zh":{"ransack":{"search":"搜索","predicate":"基于(predicate)","and":"并且","or":"或者","any":"任意","all":"所有","combinator":"条件组合(combinator)","attribute":"属性","value":"数值","condition":"条件","sort":"排序","asc":"升序","desc":"降序","predicates":{"eq":"等于","eq_any":"等于任意值","eq_all":"等于所有值","not_eq":"不等于","not_eq_any":"不等于任意值","not_eq_all":"不等于所有值","matches":"符合","matches_any":"符合任意条件","matches_all":"符合所有条件","does_not_match":"不符合","does_not_match_any":"符合任意条件","does_not_match_all":"不符合所有条件","lt":"小于","lt_any":"小于任意一个值","lt_all":"小于所有值","lteq":"小于等于","lteq_any":"小于等于任意一个值","lteq_all":"小于等于所有值","gt":"大于","gt_any":"大于任意一个值","gt_all":"大于所有值","gteq":"大于等于","gteq_any":"大于等于任意一个值","gteq_all":"大于等于所有值","in":"被包含","in_any":"被任意值包含","in_all":"被所有值包含","not_in":"不被包含","not_in_any":"不被任意值包含","not_in_all":"不被所有值包含","cont":"包含","cont_any":"包含任意一个值","cont_all":"包含所有值","not_cont":"不包含","not_cont_any":"不包含任意一个值","not_cont_all":"不包含所有值","start":"以改值开始","start_any":"以任意一个值开始","start_all":"以所有值开始","not_start":"不以改值开始","not_start_any":"不以任意一个值开始","not_start_all":"不以所有值开始","end":"以改值结尾","end_any":"以任意一个值结尾","end_all":"以所有值结尾","not_end":"不以改值结尾","not_end_any":"不以任意一个值结尾","not_end_all":"不以所有值结尾","true":"等于true","false":"等于false","present":"有值","blank":"为空","null":"是null","not_null":"不是null"}}},"de":{"ransack":{"search":"suchen","predicate":"Eigenschaft","and":"und","or":"oder","any":"beliebige","all":"alle","combinator":"Kombinator","attribute":"Attribut","value":"Wert","condition":"Bedingung","sort":"sortieren","asc":"aufsteigend","desc":"absteigend","predicates":{"eq":"gleicht","eq_any":"gleicht beliebigen","eq_all":"gleicht allen","not_eq":"ungleich","not_eq_any":"ungleich beliebigen","not_eq_all":"ungleich allen","matches":"entspricht","matches_any":"stimmt überein mit einem beliebigen","matches_all":"stimmt mit allen überein","does_not_match":"stimmt nicht überein","does_not_match_any":"erfüllt ein beliebiger/s nicht","does_not_match_all":"stimmt nicht mit allen überein","lt":"kleiner als","lt_any":"kleiner als ein beliebiger/s","lt_all":"kleiner als alle als alle","lteq":"kleiner oder gleich","lteq_any":"kleiner oder gleich beliebige","lteq_all":"kleiner oder gleich allen","gt":"größer als","gt_any":"größer als ein beliebiger/s","gt_all":"größer als alle","gteq":"größer oder gleich","gteq_any":"größer oder gleich als ein beliebiger/s","gteq_all":"größer oder gleich alle","in":"in","in_any":"ist nicht in einem beliebigen","in_all":"in allen","not_in":"nicht in","not_in_any":"nicht in beliebige","not_in_all":"nicht in allen","cont":"enthält","cont_any":"enthält beliebige","cont_all":"enthält alle","not_cont":"enthält nicht","not_cont_any":"enthält ein beliebiger/s nicht","not_cont_all":"enthält keine/s","start":"beginnt mit","start_any":"beginnt mit beliebigen","start_all":"beginnt mit allen","not_start":"beginnt nicht mit","not_start_any":"beginnt nicht mit beliebigen","not_start_all":"beginnt nicht mit allen","end":"endet mit","end_any":"endet mit beliebigen","end_all":"endet mit allen","not_end":"endet nicht mit","not_end_any":"endet nicht mit beliebigen","not_end_all":"endet nicht mit allen","true":"ist wahr","false":"ist falsch","present":"ist vorhanden","blank":"ist leer","null":"ist null","not_null":"ist nicht null"}},"ckeditor":{"page_title":"CKEditor Dateimanager","confirm_delete":"Datei löschen?","buttons":{"cancel":"Abbrechen","upload":"Hochladen","delete":"Löschen","next":"Next"}}},"el-GR":{"ckeditor":{"page_title":"CKEditor Διαχείρηση Αρχείων","confirm_delete":"Διαγραφή αρχείου;","buttons":{"cancel":"Ακύρωση","upload":"Μεταφόρτωση","delete":"Διαγραφή","next":"Next"}}},"it":{"ckeditor":{"page_title":"CKEditor Files Manager","confirm_delete":"Cancellare il file?","buttons":{"cancel":"Annulla","upload":"Carica","delete":"Elimina","next":"Next"}}},"ja":{"ckeditor":{"page_title":"CKEditor ファイル・マネージャー","confirm_delete":"ファイルを削除しますか？","buttons":{"cancel":"キャンセル","upload":"アップロード","delete":"削除","next":"次へ"}}},"nb":{"ckeditor":{"page_title":"CKEditor filbehandlingr","confirm_delete":"Slette filen?","buttons":{"cancel":"Avbryt","upload":"Last opp","delete":"Slett","next":"Neste"}}},"pl":{"ckeditor":{"page_title":"CKEditor Menadżer Plików","confirm_delete":"Usunąć plik?","buttons":{"cancel":"Anuluj","upload":"Wyślij","delete":"Skasuj","next":"Next"}}},"pt-BR":{"ckeditor":{"page_title":"Gerenciador de arquivos do CKEditor","confirm_delete":"Apagar arquivo?","buttons":{"cancel":"Cancelar","upload":"Enviar","delete":"Apagar","next":"Next"}}},"pt-PT":{"ckeditor":{"page_title":"Gestor de arquivos do CKEditor","confirm_delete":"Apagar arquivo?","buttons":{"cancel":"Cancelar","upload":"Enviar","delete":"Apagar","next":"Next"}}},"ru":{"ckeditor":{"page_title":"CKEditor Загрузка файлов","confirm_delete":"Удалить файл?","buttons":{"cancel":"Отмена","upload":"Загрузить","delete":"Удалить","next":"Показать еще"}}},"sv-SE":{"ckeditor":{"page_title":"CKEditor filhanterare","confirm_delete":"Ta bort fil?","buttons":{"cancel":"Avbryt","upload":"Ladda upp","delete":"Ta bort","next":"Next"}}},"uk":{"ckeditor":{"page_title":"CKEditor Завантаження файлів","confirm_delete":"Видалити файл?","buttons":{"cancel":"Відміна","upload":"Завантажити","delete":"Видалити","next":"Показати більше"}}},"zh-CN":{"ckeditor":{"page_title":"CKEditor - 文件管理","confirm_delete":"删除文件?","buttons":{"cancel":"取消","upload":"上传","delete":"删除","next":"下一个"}}},"zh-TW":{"ckeditor":{"page_title":"CKEditor - 文件管理","confirm_delete":"删除文件?","buttons":{"cancel":"取消","upload":"上傳","delete":"删除","next":"下一個"}}}};