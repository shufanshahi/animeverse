-- Additional functions for email-based profile operations

-- Function to get profile by email
CREATE OR REPLACE FUNCTION get_profile_by_email(user_email VARCHAR)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    email VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    street TEXT,
    zip VARCHAR,
    state VARCHAR,
    phone VARCHAR,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.user_id, p.email, p.first_name, p.last_name, 
           p.street, p.zip, p.state, p.phone, p.created_at, p.updated_at
    FROM profiles p
    WHERE p.email = user_email;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to search profiles by partial email
CREATE OR REPLACE FUNCTION search_profiles_by_email(email_pattern VARCHAR)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    email VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    street TEXT,
    zip VARCHAR,
    state VARCHAR,
    phone VARCHAR,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.user_id, p.email, p.first_name, p.last_name, 
           p.street, p.zip, p.state, p.phone, p.created_at, p.updated_at
    FROM profiles p
    WHERE p.email ILIKE '%' || email_pattern || '%';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION get_profile_by_email(VARCHAR) TO authenticated;
GRANT EXECUTE ON FUNCTION search_profiles_by_email(VARCHAR) TO authenticated;