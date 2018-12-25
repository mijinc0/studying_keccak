require_relative "../../src/func/permutation.rb"
require_relative "./testdata_for_permutation.rb"

RSpec.describe "Keccak::Permutation functions" do
  describe "Step tests" do
    # A state

    describe "Theta step" do
      A = get_deterministic_start_state
      Keccak::Permutation.theta!( A )
      after_theta = get_deterministic_after_theta_state
      it{ expect( A ).to eq after_theta }
    end

    describe "Rho and Pi step" do
      B = get_deterministic_after_theta_state
      Keccak::Permutation.rho!( B )
      Keccak::Permutation.pi!( B )
      after_rho_and_pi = get_deterministic_after_rho_and_pi_state
      it{ expect( B ).to eq after_rho_and_pi }
    end

    describe "Chi step" do
      C = get_deterministic_after_rho_and_pi_state
      Keccak::Permutation.chi!( C )
      after_chi = get_deterministic_after_chi_state
      it{ expect( C ).to eq after_chi }
    end

    describe "Iota step" do
      D = get_deterministic_after_chi_state
      Keccak::Permutation.iota!( D, 0 )
      after_iota = get_deterministic_after_iota_state
      it{ expect( D ).to eq after_iota }
    end
  end

  describe "All round test" do
    E = get_deterministic_start_state
    Keccak::Permutation.all_rounds!( E )
    after_rounds = get_deterministic_after_rounds_state
    it{ expect( E ).to eq after_rounds }
  end
end
