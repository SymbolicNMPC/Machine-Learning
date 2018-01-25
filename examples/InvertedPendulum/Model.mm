# Dynamic equations of an inverted pendulum

Model := Record(
    States = [
        x,     # [m]     position of cart
        v,     # [m/s]   velocity of cart
        theta, # [rad]   angle of pendulum
        omega  # [rad/s] angular velocity of pendulum
    ],
    InitialConditions = [
        0,
        0,
        0,
        0
    ],
    InitialCovariance = LinearAlgebra:-DiagonalMatrix(0.1^2*[1, 1, 1, 1]),
    Derivatives = [
        dx,
        dv,
        dtheta,
        domega
    ],
    ControlInputs = [
        f      # [N] force applied to cart
    ],
    ControlLowerBound = [-1],
    ControlUpperBound = [1],
    Outputs = [
        x,
        v,
        omega,
        sin(theta),
        cos(theta)
    ],
    Parameters = [
        l = 0.5, # [m]     length of pendulum
        m = 0.5, # [kg]    mass of pendulum
        M = 0.5, # [kg]    mass of cart
        b = 0.1, # [N/m/s] coefficient of friction between cart and ground
        g = 9.82 # [m/s^2] acceleration of gravity
    ],
    Equations = [
        dx = v,
        dv = ( 2*m*l*omega^2*sin(theta) + 3*m*g*sin(theta)*cos(theta) + 4*f - 4*b*v )/( 4*(M+m)-3*m*cos(theta)^2 ),
        dtheta = omega,
        domega = (-3*m*l*omega^2*sin(theta)*cos(theta) - 6*(M+m)*g*sin(theta) - 6*(f-b*v)*cos(theta) )/( 4*l*(m+M)-3*m*l*cos(theta)^2 )
    ]
);
