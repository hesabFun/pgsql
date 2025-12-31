-- Function to create a new tenant
CREATE OR REPLACE FUNCTION create_tenant(p_name VARCHAR(255), p_id UUID DEFAULT NULL)
    RETURNS UUID AS
$$
DECLARE
    v_tenant_id UUID;
BEGIN
    INSERT INTO tenants (id, name)
    VALUES (COALESCE(p_id, gen_random_uuid()), p_name)
    RETURNING id INTO v_tenant_id;

    RETURN v_tenant_id;
END;
$$ LANGUAGE plpgsql;
