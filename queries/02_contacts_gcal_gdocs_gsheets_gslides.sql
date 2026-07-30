-- Small schemas grouped together (safe to run at once)
SELECT 'contacts.contacts', to_jsonb(t) FROM contacts.contacts t
UNION ALL
SELECT 'gcal.gcal_calendars', to_jsonb(t) FROM gcal.gcal_calendars t
UNION ALL
SELECT 'gcal.gcal_events', to_jsonb(t) FROM gcal.gcal_events t
UNION ALL
SELECT 'gdocs.docs_documents', to_jsonb(t) FROM gdocs.docs_documents t
UNION ALL
SELECT 'gsheets.sheets_sheets', to_jsonb(t) FROM gsheets.sheets_sheets t
UNION ALL
SELECT 'gsheets.sheets_spreadsheets', to_jsonb(t) FROM gsheets.sheets_spreadsheets t
UNION ALL
SELECT 'gslides.slides_page_elements', to_jsonb(t) FROM gslides.slides_page_elements t
UNION ALL
SELECT 'gslides.slides_pages', to_jsonb(t) FROM gslides.slides_pages t
UNION ALL
SELECT 'gslides.slides_presentations', to_jsonb(t) FROM gslides.slides_presentations t;
