import Vapor
import JWT

struct JWTAuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Token de autenticación no encontrado")
        }
        
        // Verificar el token JWT
        let payload = try request.jwt.verify(token, as: AccessTokenPayload.self)
        
        // Buscar el usuario correspondiente
        guard let user = try await Users.find(payload.userId, on: request.db) else {
            throw Abort(.unauthorized, reason: "Usuario no encontrado")
        }
        
        // Almacenar el usuario en el contexto de la solicitud
        request.auth.login(user)
        
        return try await next.respond(to: request)
    }
}