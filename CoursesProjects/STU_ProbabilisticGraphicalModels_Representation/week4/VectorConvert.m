% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = VectorConvert(old_vec,new_vec)

  % old_assign->new_assign->new_index
  N = length(old_vec.val);
  old_assign = IndexToAssignment(1:N, old_vec.card);
  
  map_old2new_assign = [];
  for i=1:length(new_vec.var)
      curr_var = new_vec.var(i);
      old_var_index = find(old_vec.var==curr_var);
      map_old2new_assign = [map_old2new_assign,old_var_index];
  end
  new_assign = old_assign(:,map_old2new_assign);
  new_index = AssignmentToIndex(new_assign, new_vec.card);

  % return
  EU = sum(old_vec.val .* new_vec.val(new_index) );

end
