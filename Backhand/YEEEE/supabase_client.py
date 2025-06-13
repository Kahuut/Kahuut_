from supabase import create_client, Client

SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"         # <- hier deine URL
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"            # <- hier dein API-Key

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)#
