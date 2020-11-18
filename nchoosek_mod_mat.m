function mat = nchoosek_mod_mat(n)

    mat = zeros(n+1, n+1);

    for i = 0:n+1
        for j=0:i
            mat(i+1,j+1) = nchoosek_mod(i,j);
        end
    end

end